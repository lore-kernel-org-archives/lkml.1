Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXAXNxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXAXNxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXAXNxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:53:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:1676 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751468AbXAXNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:53:47 -0500
Date: Wed, 24 Jan 2007 14:53:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: 2.6.20-rc4-mm1: PCI=n: drivers/net/3c59x.c compile error
Message-ID: <20070124135354.GI17836@stusta.de>
References: <20070111222627.66bb75ab.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070111222627.66bb75ab.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

3x59x-fix-pci-resource-management.patch causes the following compile 
error with CONFIG_PCI=n:

<--  snip  -->

...
  CC      drivers/net/3c59x.o
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c: In function 'vortex_init_one':
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:961: error: implicit declaration of function 'pci_request_regions'
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:985: error: implicit declaration of function 'pci_release_regions'
make[3]: *** [drivers/net/3c59x.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXAXOMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXAXOMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXAXOMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:12:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:55169 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751487AbXAXOMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:12:31 -0500
Message-ID: <45B76946.1070009@ru.mvista.com>
Date: Wed, 24 Jan 2007 17:12:22 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-rc4-mm1: PCI=n: drivers/net/3c59x.c compile error
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070124135354.GI17836@stusta.de>
In-Reply-To: <20070124135354.GI17836@stusta.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> 3x59x-fix-pci-resource-management.patch causes the following compile 
> error with CONFIG_PCI=n:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/net/3c59x.o
> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c: In function 'vortex_init_one':
> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:961: error: implicit declaration of function 'pci_request_regions'
> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:985: error: implicit declaration of function 'pci_release_regions'
> make[3]: *** [drivers/net/3c59x.o] Error 1

    Grr, at at the same time it's happy with pci_enable_device().
    I'd say the problem is in <linux/pci.h>,  not in the patch.

> cu
> Adrian

MBR, Sergei

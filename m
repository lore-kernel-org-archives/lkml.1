Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXCTUte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXCTUte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXCTUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:49:34 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36639 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbXCTUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:49:33 -0400
Date: Tue, 20 Mar 2007 21:49:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: 2.6.21-rc4-mm1: multiple definition of `queue_pushbutton_work'
Message-ID: <20070320204936.GE752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
> +gregkh-pci-pciehp-event-handling-rework.patch
>...
>  PCI tree updates
>...

<--  snip  -->

...
  LD      drivers/pci/hotplug/built-in.o
drivers/pci/hotplug/shpchp.o: In function `queue_pushbutton_work':(.text+0x112f): multiple definition of `queue_pushbutton_work'
drivers/pci/hotplug/pciehp.o:(.text+0x1004): first defined here
make[4]: *** [drivers/pci/hotplug/built-in.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


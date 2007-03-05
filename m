Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbXCEBrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbXCEBrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXCEBrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49900 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751692AbXCEBr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:27 -0500
Date: Mon, 5 Mar 2007 02:47:28 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       dbrownell@users.sourceforge.net, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
Subject: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Message-ID: <20070305014728.GN3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
>  git-wireless.patch
>...
>  git trees
>...

<--  snip  -->

...
  CC      drivers/usb/host/ohci-hcd.o
In file included from 
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-hcd.c:931:
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: request for member 'hcd_priv_size' in something not a structure or union
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: 'ssb_ohci_device' undeclared here (not in a function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:52: error: 'ssb_ohci_reset' undeclared here (not in a function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:53: error: 'ssb_ohci_start' undeclared here (not in a function)
...
make[4]: *** [drivers/usb/host/ohci-hcd.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


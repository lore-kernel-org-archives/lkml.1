Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXCEKu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXCEKu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCEKu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:50:28 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38030
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXCEKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:50:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Date: Mon, 5 Mar 2007 11:49:05 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       dbrownell@users.sourceforge.net, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305014728.GN3441@stusta.de>
In-Reply-To: <20070305014728.GN3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051149.05664.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 02:47, Adrian Bunk wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-mm2:
> >...
> >  git-wireless.patch
> >...
> >  git trees
> >...
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/usb/host/ohci-hcd.o
> In file included from 
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-hcd.c:931:
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: request for member 'hcd_priv_size' in something not a structure or union

Seems like there was a comma missing.
There also seems to be some Kconfig problem. will fix that.

> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: 'ssb_ohci_device' undeclared here (not in a function)
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:52: error: 'ssb_ohci_reset' undeclared here (not in a function)
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:53: error: 'ssb_ohci_start' undeclared here (not in a function)
> ...
> make[4]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> 
> <--  snip  -->
> 
> 
> cu
> Adrian
> 

-- 
Greetings Michael.

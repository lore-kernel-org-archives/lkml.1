Return-Path: <linux-kernel-owner+w=401wt.eu-S966181AbXBPIdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966181AbXBPIdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBPIdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:33:35 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58763 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751894AbXBPIde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:33:34 -0500
Date: Fri, 16 Feb 2007 09:33:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/isdn/gigaset/: build asyncdata.o into the gigaset module
Message-ID: <20070216083339.GK13958@stusta.de>
References: <20070215215638.GI13958@stusta.de> <45D4F80F.8040200@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4F80F.8040200@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:17:19AM +0100, Tilman Schmidt wrote:
> Am 15.02.2007 22:56 schrieb Adrian Bunk:
> > This patch fixes the following compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   LD      drivers/isdn/gigaset/built-in.o
> > drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_skb':
> > (.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
> > drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
> > drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':
> > (.text+0x1121): multiple definition of `gigaset_m10x_input'
> > drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
> > make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1
> 
> How did you manage to produce that error? I have never encountered it.

CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_BASE=y
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
CONFIG_GIGASET_DEBUG=y
CONFIG_GIGASET_UNDOCREQ=y

It might depend on the binutils version.

> Thanks,
> Tilman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


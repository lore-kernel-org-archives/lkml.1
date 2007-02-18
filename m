Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXBRKkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXBRKkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXBRKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:40:23 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33532 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933192AbXBRKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:40:22 -0500
Date: Sun, 18 Feb 2007 11:40:28 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Kai Germaschewski <kai.germaschewski@unh.edu>
Cc: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>,
       gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
Message-ID: <20070218104028.GU13958@stusta.de>
References: <45D74B46.3090602@imap.cc> <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 12:22:10AM -0500, Kai Germaschewski wrote:
> On Sat, 17 Feb 2007, Tilman Schmidt wrote:
> 
> > Alright, then so be it. But that raises another question:
> > asyncdata.o is only needed for M105 and M101, not for the base
> > driver. How do I express in Kbuild that asyncdata.o is to be added
> > to gigaset-y only if CONFIG_GIGASET_M105 and CONFIG_GIGASET_M101
> > are not both 'n'?
> 
> The way this is typically done is via Kconfig. Add a config option 
> ASYNCDATA (actually something more descriptive/specific would be better), 
> add a "select ASYNCDATA" to the config options for m101 and m105, and then 
> you can use CONFIG_ASYNCDATA to decide whether to add asyncdata.o in the 
> Makefile.

One disadvantage of this approach is that in a kernel with 
CONFIG_GIGASET_BASE=y, you can't later compile and load the usb_gigaset 
or ser_gigaset modules without rebooting since they require a change to 
the kernel image.

> --Kai

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


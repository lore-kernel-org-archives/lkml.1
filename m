Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXIIQBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXIIQBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 12:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXIIQAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 12:00:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54118 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbXIIQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 12:00:54 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 9 Sep 2007 11:59:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Oleg Verych <olecom@flower.upol.cz>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Early userspace, Linux development (Re: perhaps init/ should
 update the reference to "change floppy")
In-Reply-To: <E1IUBUG-0003nA-W2@flower>
Message-ID: <Pine.LNX.4.64.0709091157540.15624@localhost.localdomain>
References: <Pine.LNX.4.64.0709080802430.8930@localhost.localdomain>
 <E1IUBUG-0003nA-W2@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007, Oleg Verych wrote:

> * Sat, 8 Sep 2007 08:08:06 -0400 (EDT)
> []
> >   from init/do_mounts_rd.c:
> >
> > ...
> []
> >         if (rd_prompt)
> >                 change_floppy("root floppy disk to be loaded into RAM disk");
> >         create_dev("/dev/root", ROOT_DEV);
> >         create_dev("/dev/ram", MKDEV(RAMDISK_MAJOR, n));
> >         return rd_load_image("/dev/root");
> > }
> > ...
> >
> >   but isn't it a bit archaic to suggest that an explicit ramdisk will
> > be found only on a floppy?  can't one be provided on a CD or DVD?
> > just suggesting that the terminology could probably be updated.
>
> All this is userspace code, ugly, unmaintained and all that kind of
> things.
>
> == Kernel panics without userspace, do you need such kernel? ==

um ... all i asked was whether that code should be updated to reflect
more than just floppies.  i didn't foresee the can of worms here.

rday


--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

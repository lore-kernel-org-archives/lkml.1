Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbXJLOnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbXJLOnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXJLOnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:43:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51942 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbXJLOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:43:39 -0400
Date: Fri, 12 Oct 2007 16:57:56 +0200
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071012145756.GK22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <470F7391.30800@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470F7391.30800@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bill.

Fri, Oct 12, 2007 at 09:16:01AM -0400:
[]
> >Coloring isn't useful. If it was, it would be implemented ~16 years ago.
> 
> So anything that wasn't implemented a decade ago is not useful? Virtual 
> machines, software raid, fair scheduling, jumbo packets, SMT/SMP/NUMA 
> support, support for >4GB physical memory on x86, all fluff?

Are we talking about VGA text mode or VT100 terminals? On what arch
Linux was written to run shell and to build itself?

IBM PC, if you don't know. Thus, your comment isn't funny or serious,
sorry. I also distinguish important, needed, useful, preferable.

> >>(and yes, i have implemented kernel console improvements in the past 
> >>and vga scrollback support was in fact amongst one of my first ever 
> >>Linux kernel hacks so your comment is doubly wrong.)
> >
> >This `scrollback' is usual late boot / console one. If fact useful,
> >until first tty switch or if `screen` cannot be used. But for some
> >reason if scrolling region (DECSTBM) is less than whole screen, nothing
> >works. And if width set to odd number of columns
> >
> >`stty columns $((80-1))`
> >
> >whole output becomes somewhat funny.
> 
> I think by the time you get up enough to be running ill-advised commands 
> from shell, you are past "early boot."

As i did dumb userspace coloring of kernel messages after this post,
where text from bootloader, critical stuff are visible -- i.e. no
truncated scrollback is needed, i can say, that this comment is bogus.

I don't know what `ill-advised' commands are, but knowing how pipefs
wasn't up early in <2.6.2X, i can say: *IT IS EARLY*. By me anything,
that have /dev/console as controlling tty is early.

> Your comments about scrollback not working right if you break it are
> hopefully an attempt at humor.

Cannot comment, because i don't understand this. I want scrollback in a
defined scrolling region; i what line scrolling not be cursed, if columns
number is odd.

Now i have all this in userspace *early*, so i don't care about what
ever implementors of that stuff in kernel thought.

Bye.
--
-o--=O`C
 #oo'L O
<___=E M

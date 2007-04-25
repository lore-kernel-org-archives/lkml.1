Return-Path: <linux-kernel-owner+w=401wt.eu-S2992730AbXDYNDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992730AbXDYNDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXDYNDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:03:36 -0400
Received: from mbx.ines.ro ([80.86.96.25]:47305 "EHLO mailbox.ines.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992730AbXDYNDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:03:35 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Dumitru Ciobarcianu <Dumitru.Ciobarcianu@iNES.RO>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425072904.GB6866@ucw.cz>
References: <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425064137.GA25247@elte.hu>  <20070425072904.GB6866@ucw.cz>
Content-Type: text/plain
Organization: iNES Group
Date: Wed, 25 Apr 2007 10:48:57 +0300
Message-Id: <1177487338.17755.46.camel@DustPuppy.LNX.RO>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-1) 
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Clean, Agent: BitDefender Milter 1.6.2 on MailBox.iNES.RO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 07:29 +0000, Pavel Machek wrote:
> > userspace-driven-suspend is already in the kernel, today. So it's not 
> > really "two versions side by side doing the same thing", but more of:
> > 
> >            A B C + D E F G H
> > 
> > where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used by 
> > suspend2. So any "suspend2 merge" would largely be about adding "DEFGH". 
> 
> Actually, we have 'D H' in kernel, today. It is called swsusp...
> (Encryption, swapFile support and Graphical progress are missing from
> today's kernel.)

Please stop using FUD. 
Graphical progress it's not in the kernel, even with suspend2.

> 
> > My original mail was about the following thing: i tried the suspend2 
> > patch (which just makes "echo disk > /sys/power/state" work as expected, 
> > as long as you give the booting up kernel image an idea about where the 
> 
> ..and it means that 'echo disk > ...' should work w/o suspend2 patch,
> too. (Just try it). You'll miss compression part, but that provides
> only small speedup.

I beg to differ:
  Compressed 904687616 bytes into 418828687 (53 percent compression).

Almost 500mb less to write (did I mention it writes the full image?).
Now imagine the time it takes to write that with those pesky 4200rpm
laptop hdds.

-- 
Cioby

"Mr Linus, how do you debug the kernel, what tools do you use?"
"Ever heard of prinf ?"
(From an presentation at the "Politehnica" University of Bucharest, 1995)


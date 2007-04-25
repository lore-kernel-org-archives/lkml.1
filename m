Return-Path: <linux-kernel-owner+w=401wt.eu-S1423287AbXDYIYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423287AbXDYIYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423288AbXDYIXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:23:53 -0400
Received: from mbx.ines.ro ([80.86.96.25]:59504 "EHLO mailbox.ines.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423285AbXDYIXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:23:51 -0400
X-Greylist: delayed 2013 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 04:23:51 EDT
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
In-Reply-To: <20070425081051.GA7221@ucw.cz>
References: <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425064137.GA25247@elte.hu> <20070425072904.GB6866@ucw.cz>
	 <1177487338.17755.46.camel@DustPuppy.LNX.RO> <20070425081051.GA7221@ucw.cz>
Content-Type: text/plain
Organization: iNES Group
Date: Wed, 25 Apr 2007 11:22:21 +0300
Message-Id: <1177489341.17755.49.camel@DustPuppy.LNX.RO>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-1) 
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Clean, Agent: BitDefender Milter 1.6.2 on MailBox.iNES.RO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 08:10 +0000, Pavel Machek wrote:
> Hi!
> 
> > > > userspace-driven-suspend is already in the kernel, today. So it's not 
> > > > really "two versions side by side doing the same thing", but more of:
> > > > 
> > > >            A B C + D E F G H
> > > > 
> > > > where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used by 
> > > > suspend2. So any "suspend2 merge" would largely be about adding "DEFGH". 
> > > 
> > > Actually, we have 'D H' in kernel, today. It is called swsusp...
> > > (Encryption, swapFile support and Graphical progress are missing from
> > > today's kernel.)
> > 
> > Please stop using FUD. 
> > Graphical progress it's not in the kernel, even with suspend2.
> 
> It was ascii-art, but still 'graphical', last time I checked.

That would be suspend2ui_text , an userspace app.
It also works without it.

-- 
Cioby



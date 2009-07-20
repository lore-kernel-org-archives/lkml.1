Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZGTWC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZGTWC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZGTWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbZGTWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:02:54 -0400
Date: Mon, 20 Jul 2009 15:02:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kiko Piris <kernel@pirispons.net>
cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
In-Reply-To: <20090720211908.GA31814@superlopez.pirispons.net>
Message-ID: <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <20090720192933.GA22641@superlopez.pirispons.net> <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain>
 <20090720211908.GA31814@superlopez.pirispons.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Kiko Piris wrote:
> > Just to clarify:
> > 
> >  - you literally have a _working_ 2.6.30.1 that you compiled yourself a 
> >    few days ago.
> 
> That¢s correct.
> 
> >  - But when you try to compile that same kernel _now_, it fails with an 
> >    immediate reboot? And not just 2.6.30.2, but 2.6.30.1 does that too?
> 
> Also correct.
> 
> > That certainly implies something else than just the -fwrapv vs 
> > -fno-strict-overflow thing.
> 
> Yes, as Marcel Beister pointed, it resulted some binutils bug.
> Downgrading the package produced a perfectly bootable 2.6.30.2.

Ok, so it's been narrowed down to binutils. Good.

> > But we may be looking at two different issues, so maybe your "unable to 
> > compile a working kernel" issue is different from the other reports.
> 
> Totally unrelated to other reports, and not a kernel bug, in fact.

Well, it's still not entirely clear that it's unrelated.

It seems that all the people involved are running Debian/sid, and I don't 
think we have any firm confirmation yet that it's the compiler flag for 
anybody. It was certainly the primary suspect, but maybe that was always 
just a red herring guess.

Wolfgang hasn't actually tried to compile without the -fno-strict-overflow 
flag yet, and maybe his hang is the same binutils bug.

Of course, maybe I missed some gcc flag confirmation that wasn't cc'd to 
me. So who knows..

		Linus

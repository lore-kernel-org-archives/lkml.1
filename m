Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0BMGUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 01:20:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54507 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0BMGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 01:20:12 -0500
Date: Sat, 13 Feb 2010 07:20:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100213062004.GA22848@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
 <4B75A5DC.3060803@kernel.org>
 <20100212202357.6363d5af@hyperion.delvare>
 <20100212230702.GA10266@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212230702.GA10266@1wt.eu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It's probably worth keeping things like the .gz files around, if nothing
> > > else for older distros, systems, etc that don't have xz yet (since it's
> > > still relatively new)
> > 
> > Hardly a good reason IMHO. xz can be installed on these systems. When
> > we switched to git, nobody had it and it did not stop us.
> 
> I don't agree, it's different. Git is only used by developers, and even
> not all of them. Sources are a reference. Anyone can download them to
> look for anything. Switching to a specific format which really is not
> common at all on older distros nor on any system looks a bit like
> proprietary encoding eventhough it's not the case. But it's a way to
> tell people that if they want the sources in clear text form, they
> first have to find a tool capable of decompressing them. Gzip is well
> defined as a standard, it's even described in an RFC and is present
> on almost any system (unix or not) now. Any student who wants to take
> a look at the kernel will have access to gunzip, even from an old
> Solaris 8 workstation or a Windows XP desktop PC. XZ if far from
> being there, and the student will not necessarily be able to install
> it. And Peter raised some valid points about the hardware requirements
> to run such tools ; I'm not sure the guys running Linux on their old
> Sparc-2 would like XZ only a lot.

It is not just student on old workstation. I'm trying to keep Linux
working on spitz PDA and kohjinsha subnotebook. Especially zaurus has
about power of old sparc two... otoh it runs 4 hours on cellphone
battery.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

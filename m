Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYEQO6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYEQO6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYEQO6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:58:23 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42269 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755334AbYEQO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:58:22 -0400
Date: Sat, 17 May 2008 10:58:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Message-ID: <20080517145802.GB6978@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <20080517015705.GA20375@mit.edu> <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 08:19:04PM -0700, Linus Torvalds wrote:
> > Why do you consider rebasing topic branches a bad thing?
> 
> Rebasing branches is absolutely not a bad thing for individual developers.
> 
> But it *is* a bad thing for a subsystem maintainer.

Right, but so long as a subsystem maintainer doesn't publish his/her
topic branches, and only sends out patches on their topic branches for
discussion via e-mail, they're fine, right?  They can just rebase up
until the point where the patch goes on a non-'pu' or non-'linux-next'
branch.

Basically, this would be the subsystem maintainer sometimes wearing an
"end-point-developer" hat, and sometimes wearing a "subsystem
maintainer" hat.  So rebasing is fine as long as it's clear that it's
happening on branches which are not meant as a base for
submaintainers.  

I believe Junio does this himself for his own topic branches while
developing git, yes?  And that's probably a good reason for him not
actually *publishing* any of his topic branches, and only the 'pu'
branch, which is well known to be a bad idea for folks to use as a
branch point, since it is constantly getting rebased.

> And I realize that the x86 tree doesn't do git merges from other 
> sub-maintaines of x86 stuff, and I think that's a problem waiting to 
> happen. It's not a problem as long as Ingo and Thomas are on the net every 
> single day, 12 hours a day, and respond to everything. But speaking from 
> experience, you can try to do that for a decade, but it won't really work.
> 
> I've talked to Ingo about this a bit, and I'm personally fairly convinced 
> that part of the friction with Ingo has been that micro-management on a 
> per-patch level. I should know. I used to do it myself. And I still do it, 
> but now I do it only for really "core" stuff. So now I get involved in 
> stuff like really core VM locking, or the whole BKL thing, but on the 
> whole I try to be the anti-thesis of a micro-manager, and just pull from 
> the submaintainers.

Heh, can't really argue with your point here.

							- Ted

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZJWVDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZJWVDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZJWVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:03:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZJWVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:03:12 -0400
Subject: Re: [kernel.org users] Please remember to run 'git gc' on your
 repositories
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luck, Tony" <tony.luck@intel.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4AE21839.3000000@s5r6.in-berlin.de>
References: <4ADD0793.3000707@kernel.org>
	 <20091020020449.GF24370@core.coreip.homeip.net>
	 <20091020034829.GA12833@elte.hu> <20091020140750.GH11972@erda.amd.com>
	 <alpine.LFD.2.00.0910210654480.5125@eeepc.linux-foundation.org>
	 <20091022122042.e535d43c.sfr@canb.auug.org.au>
	 <20091023112732.GB5886@elte.hu>	<4AE19A74.1090709@garzik.org>
	 <20091023123555.GA25366@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
	 <20091023134115.GD27097@elte.hu>
	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
	 <4AE21839.3000000@s5r6.in-berlin.de>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 23 Oct 2009 17:03:14 -0400
Message-Id: <1256331794.26028.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ took off users.kernel.org and added LKML ]

There's a thread started on LKML, search for the subject:


"[RFC] to rebase or not to rebase on linux-next" (thanks Ingo for the
typo fix).

And continue this conversation there.

Thanks!

-- Steve



On Fri, 2009-10-23 at 22:55 +0200, Stefan Richter wrote:
> Nicolas Pitre wrote:
> > On Fri, 23 Oct 2009, Ingo Molnar wrote:
> > 
> >> linux-next should not be used as a 'test and rebase' feedback loop for 
> >> build-broken, unbisectable crap. Why do you think it should be used for 
> >> that?
> > 
> > I've been under the impression that linux-next has been created exactly 
> > for that: a tree that pulls everything together for testing and early 
> > merge conflict resolutions, and to be thrown away the next day when the 
> > process is repeated again.  It is indeed exactly that: a "test and 
> > rebase" feedback tree where the big picture can be assessed before stuff 
> > is headed for Linus's tree where commits are then stable.
> > 
> > To my knowledge, unlike Linus's tree, linux-next was never meant to be a 
> > stable tree itself, nor its components.
> [...]
> 
> The trees which are pulled into linux-next are supposed to be
> unit-tested.  It is material which you would ask Linus to pull if he had
> a merge window open today.  The only thing that this material may still
> lack is integration testing (and exposure to mainline's huge userbase of
> course).
> 
> I have doubts that the majority of build errors which linux-next
> frequently encounters are purely integration related.


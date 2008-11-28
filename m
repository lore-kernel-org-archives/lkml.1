Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYK1Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYK1Vax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYK1Van
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:30:43 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52318 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYK1Van (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:30:43 -0500
Date: Fri, 28 Nov 2008 14:30:41 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Alex Chiang <achiang@hp.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
Message-ID: <20081128213041.GW25548@parisc-linux.org>
References: <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net> <20081127024204.GJ25548@parisc-linux.org> <Pine.LNX.4.58.0811280151230.24816@shell4.speakeasy.net> <20081128185722.GU25548@parisc-linux.org> <Pine.LNX.4.58.0811281310050.30153@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0811281310050.30153@shell4.speakeasy.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 01:21:22PM -0800, Trent Piepho wrote:
> Sometimes I just want to give up on Linux.  Is there a different interface
> that isn't wantonly changed without warning?  No?  Do you not see the
> problem this creates for developers?  Do you not care?

You see, we didn't know that anyone was using fakephp for real work.
It's marketed as being a way for developers to test their device drivers
with hotplug slots even if they don't have a real hotplug machine.
If we'd known, we'd've done a better job.

BTW, cut the crap about "Sometimes I just want to give up on Linux".
We're putting in a lot of work that you get to use for free.  That doesn't
give you the right to be abusive.  And if you stopped using Linux, we'd
have one fewer person complaining, so I don't personally find it a huge
motivator to drop everything and attend to your whims.

> > What we have now is the 'address' file managed by the core.  This
> > doesn't include the function number.
> 
> So the race condition doesn't matter?  Alex Chiang wasn't even aware
> fakephp could be used to add new devices, so this change obviously wasn't
> though out very well.

There is no race condition.  You can't remove a fakephp slot.

> > There are lots of circumstances where enabling and disabling individual
> > functions is a good idea, but I don't think that fakephp is the right
> > way to do it.  We need a better interface.
> 
> So maybe this better interface should be created before breaking the
> existing one?

Hey, I have a great idea.  Why don't you help instead of just bitching?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

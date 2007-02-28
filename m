Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbXB1STw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbXB1STw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbXB1STw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:19:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbXB1STv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:19:51 -0500
Date: Wed, 28 Feb 2007 10:20:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Jiri Kosina wrote:

> On Wed, 28 Feb 2007, Linus Torvalds wrote:
> 
> > There is no excuse for putting a large array in a header file and 
> > including it millions of times. Or even just twice. The point of a 
> > header file is to *declare* things, not to have big data structures in.
> 
> The point was that noone else than hid/hid-core.c would ever be going to 
> include this header with blacklist.

So:
 - clearly other people *do* include it.
 - if no-one else incldues it WHY HAVE IT SEPARATE!
 - if you want to have it separate for other reasons, YOU MAKE IT A .c 
   FILE, SINCE IT'S CLEARLY NOT A HEADERFILE!

In other words, there is *zero* excuse for that braindamage.

> But OK, I will leave it in there.

No. You need to realize just WHY it was wrong. Not just an "But OK".

Because if you don't see why I'm complaining, I can't pull from you. You 
can send me patches, but for me to pull a git patch from you, I need to 
know that you know what you're doing, and I need to be able to trust 
things *without* then having to go and check every individual change by 
hand.

If I have to check changes like this by hand, I want you to send patches 
to the mailing list, so that other people can help me filter it out. It 
really is that simple, and that fundamental. It's about code flow, and 
it's about the fact that there's no way I can look at every change and vet 
it for being sane.

I simply *cannot* do git-to-git merges with people I can't trust to have 
good enough judgement that I don't need to do the micromanagement and 
check everything myself. I can't afford to. I don't have the bandwidth, 
but I also simply don't have the interest in micro-managing.

So people I do git merges with need to show that they have good taste and 
skills, otherwise it needs to be done as open patches where *other* people 
with good taste and skills can help me.

		Linus



Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbXK1VUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbXK1VUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbXK1VUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:20:24 -0500
Received: from 1wt.eu ([62.212.114.60]:2491 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbXK1VUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:20:23 -0500
Date: Wed, 28 Nov 2007 22:20:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-ID: <20071128212016.GA19331@1wt.eu>
References: <474C9B31.8000408@imap.cc> <20071127235511.bd9557f0.Kristoffer.ericson@gmail.com> <20071127235237.GF15227@1wt.eu> <474D6F3A.6020906@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474D6F3A.6020906@imap.cc>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 02:38:02PM +0100, Tilman Schmidt wrote:
> Willy,
> 
> thanks for your kind answer.
> 
> Am Mi 28 Nov 2007 00:52:38 +0100, Willy Tarreau schrieb:
> > Tilman, there was a howto by Jeff Garzik I believe.
> 
> Yes, I started from that and it's fine as far as it goes. The
> "Everyday GIT With 20 Commands Or So" document was quite helpful
> too, especially the section "Individual Developer (Participant)".
> But they don't quite cover my workflow yet.
> 
> > The tutorials
> > on the GIT site are quite good too. You must read them entirely and
> > proceed with the examples as you read them. Believe me, it helps you
> > understand a lot of things, specially about the split in 3 parts
> > (objects, cache, and working dir).
> 
> I think I got that part. My questions concern practical things
> like when to make a new branch, how to resubmit a patch following
> post-commit changes, what to do when "git format-patch" doesn't
> produce the desired result

I don't see how it can fail, I use it a lot (I would say exclusively)
to move patch between branches and never had a problem with it.

> or when "git pull" obstinately declares "Already up-to-date" even
> though I know that isn't true,

As frustrating as it can be, git is true. It is possible that you
have already merged the branch at an earlier step and that there
is nothing new to be merged. I really think that there is a little
thing wrong in your workflow that you need to find out to solve
your problems.

> how to
> track a patch after submission to LKML to see when or whether it
> appears in the main tree, or how to scrub the history to stop
> "git log origin..HEAD" from listing (and "git format-patch" from
> formatting) long-merged changes as new. Well, I'll take that up on
> the git@vger.kernel.org list then, as proposed by J. Bruce Fields,
> in order not to annoy LKML readers any longer.

Yes, at this stage it's more a GIT-specific topic.

> > Anyway, don't get demotivated about the tool or the workflow. If
> > you find it inconvenient to use, you're doing something wrong and
> > you don't know it.
> 
> That's what I'm thinking. What I'm trying to do can't be that
> different from what all those happy git users are doing. I guess
> if I could just watch an experienced git user at work for a day
> most of my problems would vanish.

That's probably true. When I started, I whined about it because I
didn't understand it (nor the workflow). Marcello took the time
to explain me how he proceeded and from that point I started to
understand my mistakes and to become more and more a happy user.

Try to be descriptive about the things you do that don't work and
that you don't understand why, and post that to the GIT ML. I'm
sure someone there will be able to wipe out all your problems.

Regards,
Willy


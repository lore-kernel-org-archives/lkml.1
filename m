Return-Path: <linux-kernel-owner+w=401wt.eu-S1765273AbYD3Vrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765273AbYD3Vrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761184AbYD3Vrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:47:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760950AbYD3Vrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:47:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 23:47:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430.142137.236846072.davem@davemloft.net>
In-Reply-To: <20080430.142137.236846072.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302347.13688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 30 Apr 2008 13:54:05 -0700
> 
> > linux-next does little to address our two largest (IMO) problems:
> > inadequate review and inadequate response to bug and regression reports. 
> > But those problems are harder to fix..
> 
> This is all about positive and negative reinforcement.
> 
> The people who sit and git bisect their lives away to get the
> regressions fixed need more positive reinforcement.  And the people
> who stick these regressions into the tree need more negative
> reinforcement.
> 
> The current way of dealing with folks who stick broken crud into the
> tree results in zero change in behvaior.
> 
> People who insert the bum changes into the tree only really have one
> core thing that they are sensitive to, their reputation.  That's why
> there is an enormous reluctance to even suggest reverts, it looks bad
> for them and it also makes more work for them in the end.
> 
> I guess what these folks are truly afraid of is that someone will
> start tracking reverts and post their results in some presentation
> at some big conference.  I say that would be a good thing.  To
> be honest, hitting the revert button more aggressively and putting
> the fear of being the "revert king" into everyone's minds might
> really help with this problem.

Well, probably ...

> Currently there is no sufficient negative pushback on people who
> insert broken crud into the tree.  So it should be no surprise that it
> continues.

... but that should also point at the trees through which the bugs are
introduced.

I mean, the maintainers should be more careful for what they take to their
trees and push upstream.  If that happens, they'll (hopefully) put some more
pressure on patch submitters.

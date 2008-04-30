Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbYD3VVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbYD3VVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbYD3VVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:21:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49904
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbYD3VVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:21:38 -0400
Date: Wed, 30 Apr 2008 14:21:37 -0700 (PDT)
Message-Id: <20080430.142137.236846072.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430135405.ddc42075.akpm@linux-foundation.org>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080430135405.ddc42075.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 30 Apr 2008 13:54:05 -0700

> linux-next does little to address our two largest (IMO) problems:
> inadequate review and inadequate response to bug and regression reports. 
> But those problems are harder to fix..

This is all about positive and negative reinforcement.

The people who sit and git bisect their lives away to get the
regressions fixed need more positive reinforcement.  And the people
who stick these regressions into the tree need more negative
reinforcement.

The current way of dealing with folks who stick broken crud into the
tree results in zero change in behvaior.

People who insert the bum changes into the tree only really have one
core thing that they are sensitive to, their reputation.  That's why
there is an enormous reluctance to even suggest reverts, it looks bad
for them and it also makes more work for them in the end.

I guess what these folks are truly afraid of is that someone will
start tracking reverts and post their results in some presentation
at some big conference.  I say that would be a good thing.  To
be honest, hitting the revert button more aggressively and putting
the fear of being the "revert king" into everyone's minds might
really help with this problem.

Currently there is no sufficient negative pushback on people who
insert broken crud into the tree.  So it should be no surprise that it
continues.

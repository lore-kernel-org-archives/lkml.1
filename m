Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbXEUGmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbXEUGmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXEUGmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:42:14 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:58296
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXEUGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:42:14 -0400
Date: Sun, 20 May 2007 23:41:50 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521064150.GC4442@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521060828.GB20277@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 08:08:28AM +0200, Ingo Molnar wrote:
> To me it appears Peter's stuff is already a pretty complete solution on 
> its own, and it's a whole lot simpler (and less duplicative) than your 
> lockstat patch. Could you list the specific items/features that you 
> think Peter's stuff doesnt have?

First of all, this isn't an either/or kind of thing nor should it be thought
of in that way.

Precise file/function/line placement for one thing. My patch is specifically
for -rt which does checks that Peter's doesn't and is needed to characterize
-rt better. My stuff is potentially more extensible since I have other ideas
for it that really are outside of the lockdep logic currently. These can be
unified, but not so that one overrides the intended features of other. That's
why I was hessitant to completely unify with lockdep in the manner you
suggested.

bill


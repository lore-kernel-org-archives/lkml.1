Return-Path: <linux-kernel-owner+w=401wt.eu-S967983AbXEHFig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967983AbXEHFig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967977AbXEHFic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:38:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967951AbXEHFi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:38:29 -0400
Date: Mon, 7 May 2007 22:37:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: sleeping function called from invalid context at
 block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-Id: <20070507223738.57d763da.akpm@linux-foundation.org>
In-Reply-To: <20070508053132.GZ31925@holomorphy.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<463E3C50.9080207@simon.arlott.org.uk>
	<20070506135403.a6785f7d.akpm@linux-foundation.org>
	<463FAF1C.8060500@simon.arlott.org.uk>
	<20070507162349.0790706f.akpm@linux-foundation.org>
	<463FB697.6060902@simon.arlott.org.uk>
	<20070507163335.f5f5ea6e.akpm@linux-foundation.org>
	<463FFD0A.2050708@goop.org>
	<20070507222409.2d597a86.akpm@linux-foundation.org>
	<20070508053132.GZ31925@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 22:31:32 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >> I'm using wli's 8k
> >> stack + irq stack patches with good success though.
> 
> On Mon, May 07, 2007 at 10:24:09PM -0700, Andrew Morton wrote:
> > wlis are handy.
> 
> I think Andi's handling the mergework on those patches, but I'll check
> in to see if I should rediff vs. -mm or what if you want them.
> 
> Andi, what's the verdict on those stack patches?
> 

Whoa. The verdict is usually "don't use so much stack".

Do we know what has gone wrong here?

Last week Jens said he was picking up the ancient
md-dm-reduce-stack-usage-with-stacked-block-devices.patch, but he doesn't
seem to have done so yet.

XFS is frequently implicated.

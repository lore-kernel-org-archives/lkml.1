Return-Path: <linux-kernel-owner+w=401wt.eu-S966159AbXEHI74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966159AbXEHI74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966124AbXEHI7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:59:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57423 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965760AbXEHI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:59:54 -0400
Date: Tue, 8 May 2007 10:59:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-ID: <20070508085950.GB8034@one.firstfloor.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org> <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org> <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org> <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org> <20070508053132.GZ31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508053132.GZ31925@holomorphy.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:31:32PM -0700, William Lee Irwin III wrote:
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

I planned to merge them partially. Add the separate 4/8/irqstack options,
add the vmalloc support, but not support the > 8K stacks. Haven't yet.

-Andi

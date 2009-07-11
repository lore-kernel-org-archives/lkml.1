Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZGKKQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZGKKQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 06:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZGKKP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 06:15:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53731 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZGKKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 06:15:56 -0400
Date: Sat, 11 Jul 2009 04:15:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, tony.luck@intel.com, rth@twiddle.net,
       geert@linux-m68k.org
Subject: Re: [PATCH 1/2] sched: INIT_PREEMPT_COUNT
Message-ID: <20090711101554.GA24310@parisc-linux.org>
References: <20090710125755.559739294@chello.nl> <20090710130125.037018244@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710130125.037018244@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 02:57:56PM +0200, Peter Zijlstra wrote:
> Pull the initial preempt_count value into a single
> definition site.
> 
> Maintainers for: alpha, ia64 and m68k, please have a look,
> your arch code is funny.

Goodness.  I remember sending patches to fix the initial value of
preempt_count on these architectures about four-five years ago.
Guess they were ignored.  It just shows that we need to keep pulling
stuff out of arch/.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

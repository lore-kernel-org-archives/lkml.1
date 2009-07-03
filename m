Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZGCG5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZGCG5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCG5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:57:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGCG5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:57:35 -0400
Date: Fri, 3 Jul 2009 08:56:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       yinghai@kernel.org, tglx@linutronix.de, mikpe@it.uu.se,
       alex.shi@intel.com, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: add boundary check for 32bit res before
	expand e820 resource to alignment
Message-ID: <20090703065632.GB32687@elte.hu>
References: <tip-4b05c392955458757790414bd7ba4280e1a515b0@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4b05c392955458757790414bd7ba4280e1a515b0@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:

> Commit-ID:  4b05c392955458757790414bd7ba4280e1a515b0
> Gitweb:     http://git.kernel.org/tip/4b05c392955458757790414bd7ba4280e1a515b0
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Thu, 2 Jul 2009 11:10:56 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 2 Jul 2009 11:53:15 -0700
> 
> x86: add boundary check for 32bit res before expand e820 resource to alignment
> 
> Avoid incorrect address arithmetic, ascerbated by previous improper
> definition of the round_up() macro.
> 
> fix hang with HIGHMEM_64G and 32bit resource.
> according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.
> analyized by hpa
> 
> Alex found:
> for i386 machine the specjbb2005 still can not run with hugepage
> 
> -v2: it also fix hugepage problem
> 
> Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
> Reported-and-Tested-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Peter, Yinghi - i zapped this and the other e820 patch from 
x86/urgent as Linus already applied slightly different versions 
upstream:

7c5371c: x86: add boundary check for 32bit res before expand e820 resource to alignment
4364467: x86: fix power-of-2 round_up/round_down macros

Mind checking what the differences are and queue up any deltas that 
might still be needed?

Thanks,

	Ingo

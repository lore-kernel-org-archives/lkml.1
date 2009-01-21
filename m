Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbZAUL26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbZAUL26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZAUL2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:28:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbZAUL2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:28:48 -0500
Date: Wed, 21 Jan 2009 12:28:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: venkatesh.pallipadi@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 warnings in arch/x86/mm/pageattr.c:560
Message-ID: <20090121112835.GF23469@elte.hu>
References: <20090120091837.GC19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120091837.GC19505@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> I've been getting this warning intermittently since the merge window
> opened. Considering that track_pfn_vma_new is called before the ptes
> are set up in remap_pfn_range (and remap_pfn_range contains a warning
> if the ptes *are* nonzero), I don't know how this is supposed to work?
> 
> Anyway, I can of course test patches.
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0x9ef/0xa00()
> Hardware name: empty
> CPA: called for zero pte. vaddr = ffff8800cff4e000 cpa->vaddr = ffff8800cff4e000

Ok, i have just queued up a fix that could address this - could you please 
try latest tip/master:

   http://people.redhat.com/mingo/tip.git/README

does it still produce that warning?

	Ingo

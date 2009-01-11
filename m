Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZAKCFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZAKCFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZAKCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:05:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZAKCFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:05:22 -0500
Date: Sun, 11 Jan 2009 03:05:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: venkatesh.pallipadi@intel.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/6] PAT fixes/cleanup following the pfnmap changes
Message-ID: <20090111020508.GA29153@elte.hu>
References: <20090110001308.403550000@intel.com> <49689C80.3070905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49689C80.3070905@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> venkatesh.pallipadi@intel.com wrote:
> > Individual patch header has descriptions.
> > 
> 
> $ git am Patches
> Applying: x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
> error: patch failed: mm/memory.c:1604
> error: mm/memory.c: patch does not apply
> Patch failed at 0001.
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
> 
> These do not apply for me to latest Linus git, which is the tree where I 
> experienced the problem.  Is there some way to fuzz them to get them to 
> apply?

Could you check tip/master:

  http://people.redhat.com/mingo/tip.git/README

do you still get the messages? [ Btw., did you also experience any 3D 
performance problems that are solved via Venki's fixes in tip/master? ]

	Ingo

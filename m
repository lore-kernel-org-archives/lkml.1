Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYHVGlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYHVGlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYHVGlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:41:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYHVGlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:41:31 -0400
Date: Fri, 22 Aug 2008 08:41:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH] x86: make gart_alloc_coherent return zeroed memory
Message-ID: <20080822064107.GS14110@elte.hu>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp> <1219339707-30592-1-git-send-email-joerg.roedel@amd.com> <20080822081517F.fujita.tomonori@lab.ntt.co.jp> <20080822063530.GA16706@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822063530.GA16706@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> > This should be foiled to the first patch in the patchset. No good 
> > reason to push a patch that might cause a problem.
> 
> The reason is, that in my experience, Ingo prefers update patches 
> instead replacements once he has merged something.

yeah, that's very true - but i can also fold back things if it's done in 
a reasonably short amount of time, when there's no other commits mixed 
in inbetween. (as in this case)

	Ingo

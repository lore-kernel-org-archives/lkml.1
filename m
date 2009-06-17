Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbZFQO1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbZFQO1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbZFQO1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:27:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbZFQO1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:27:25 -0400
Date: Wed, 17 Jun 2009 16:27:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090617142719.GC6846@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <20090617142151.GB6846@elte.hu> <8C6954A9-BE4C-47F5-AD87-A1D0EAF43F8A@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C6954A9-BE4C-47F5-AD87-A1D0EAF43F8A@kernel.crashing.org>
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


* Kumar Gala <galak@kernel.crashing.org> wrote:

> On Jun 17, 2009, at 9:21 AM, Ingo Molnar wrote:
>
>> * Paul Mackerras <paulus@samba.org> wrote:
>>
>>> This depends on the generic atomic64_t patches, which are now in 
>>> Linus' tree.  Ingo, if you're putting these in, please pull 
>>> Linus' tree in first.
>>
>> Note, i've created a new branch, tip:perfcounters/powerpc, so we 
>> can keep these things separate and Ben can pull them too. I see 
>> there was some review feedback - do you want to send a v2 version 
>> perhaps?
>
> Out of interest, is the intent to try and get these changes into 
> .31?  I ask because I want to know if I should try to find time to 
> add support for the FSL embedded perfmon ASAP or not.

I think it would be nice to have more platform support in .31. 
Perfcounters is a brand-new feature so there's no risk of 
regression. In the end it will depend on Linus to pull of course, 
and BenH can veto it too if he'd like no more PowerPC changes in 
this cycle. Worst-case it's all .32 material.

	Ingo

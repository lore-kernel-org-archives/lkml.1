Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbZKZJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbZKZJ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbZKZJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:26:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760162AbZKZJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:26:44 -0500
Date: Thu, 26 Nov 2009 10:26:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the tip tree
Message-ID: <20091126092631.GA17253@elte.hu>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
 <20091126081237.GA31034@elte.hu>
 <4B0E4741.10509@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E4741.10509@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> 11/26/2009 05:12 PM, Ingo Molnar wrote:
> > Please submit scheduler patches to the scheduler tree. Such level of 
> > refactoring of a critical scheduler component needs to go through the 
> > regular scheduler channels. This is a frequently modified piece of code 
> > and conflicts are likely in the future.
> 
> Sure, which sched/* branch should I base these patches on?

You could send the patch you rely on standalone (it seems to be a single 
patch) and we can look at applying it to the scheduler tree. That 
reduces the conflicts on an ongoing basis. Please Cc: PeterZ and Mike 
Galbraith as well.

Thanks,

	Ingo

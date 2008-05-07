Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbYEGIYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbYEGIYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYEGIYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:24:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYEGIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:24:18 -0400
Date: Wed, 7 May 2008 10:24:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: audio skipping on 2.6.26-rc1
Message-ID: <20080507082405.GA22821@elte.hu>
References: <E1JteVx-0003ro-2h@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JteVx-0003ro-2h@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> On a T60 I get occasional (but very annoying) audio skips while 
> compiling kernels.  No kernels (as long as I remeber) prior to this 
> had any similar problems.
> 
> It's reproducible, but takes some minutes to get reliably.  Please 
> don't tell me to bisect it :)

please try latest -git [it has scheduler interactivity fixes], does it 
work any better?

and also turn off:

> # CONFIG_CGROUPS is not set
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y

as it still causes more latencies than it should (even in 
sched-devel/latest), and the reason is still not understood.

	Ingo

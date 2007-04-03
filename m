Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXDCIvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXDCIvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXDCIvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:51:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372AbXDCIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:51:39 -0400
Date: Tue, 3 Apr 2007 10:51:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Sperry <dave_sperry@ieee.org>
Cc: "'dave_sperry@ieee.org'" <dasperry@comcast.net>,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Message-ID: <20070403085132.GA15344@elte.hu>
References: <20070402190445.GB2081@elte.hu> <001d01c77584$6a92ffe0$7901a8c0@dad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001d01c77584$6a92ffe0$7901a8c0@dad>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Sperry <dave_sperry@ieee.org> wrote:

> > there are a few other things i'm working on to improve this. I've 
> > uploaded -rt9 which is the current state of affairs. Note that using 
> > -rt9 you'll likely only see IRQ-8406 overhead in the system, because 
> > i've added an optimization to do process the softirq-net-tx workload 
> > in the hardirq thread if the priority of the two is the same (which 
> > is the default behavior). But -rt9 is still work in progress that is 
> > not fully finished yet: in some cases i'm seeing 'fluctuating 
> > performance' problems on forcedeth that werent there before.
> 
> I tried -rt9 and saw some odd 'fluctuating performance'. I'll try it 
> again tomorrow when I am much closer to the box's power button.

could you try -rt10? I've improved hardirq/softirq threading performance 
some more, and have tuned the forcedeth driver too.

	Ingo

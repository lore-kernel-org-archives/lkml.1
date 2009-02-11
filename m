Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZBKM77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZBKM77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZBKM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:59:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41586 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbZBKM7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:59:50 -0500
Date: Wed, 11 Feb 2009 13:59:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <lin@minggr.cn>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
Message-ID: <20090211125931.GL16535@elte.hu>
References: <20090205112414.104100700@chello.nl> <20090205120608.GB8799@elte.hu> <d3f22a0902091848y43661118ie4ddf90e44357c46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3f22a0902091848y43661118ie4ddf90e44357c46@mail.gmail.com>
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


* Lin Ming <lin@minggr.cn> wrote:

> On Thu, Feb 5, 2009 at 8:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >> This should hopefully address all the itimer borkage.
> >
> > Applied to tip:timers/urgent, thanks Peter!
> >
> > Yanmin: could you check hacbench_pth with latest tip/master, do
> > these fixes resolve that 3% regression you reported?
> 
> hacbench_pth still has regression with 2.6.29-rc4.
> Below 2 patches that fixed the regression are not merged into 2.6.29-rc4.
> 
> commit 32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Feb 5 12:24:15 2009 +0100
> 
>     signal: re-add dead task accumulation stats.
> 
> commit 4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Feb 5 12:24:16 2009 +0100
> 
>     timers: split process wide cpu clocks/timers

they are queued up but not fully baken yet. Maybe in -rc5.

	Ingo

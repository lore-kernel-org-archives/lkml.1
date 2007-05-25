Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbXEYIcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbXEYIcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXEYIcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:32:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXEYIcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:32:00 -0400
Date: Fri, 25 May 2007 10:31:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] i386, numaq: enable TSCs again
Message-ID: <20070525083153.GA27236@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080827.GA22399@elte.hu> <20070525081944.GZ31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525081944.GZ31925@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> > Andi, Andrew, do you remember why we disabled TSCs on NUMAQ? It was 
> > slightly async between CPUs, right? In that case we should try the 
> > patch below.
> 
> I remember. It was far beyond "slightly async;" they would drift 
> minutes apart during reasonable amounts of uptime, though it would 
> take at least several days to drift so far (I don't recall how long it 
> took).

yes, that's what i meant under 'slightly async'. Some AMD CPUs are like 
that too and sched_clock() now handles that fine. So we should try my 
patch.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZIHLgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZIHLgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZIHLgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:36:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZIHLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:36:04 -0400
Date: Tue, 8 Sep 2009 13:35:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Pekka Pietikainen <pp@ee.oulu.fi>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908113554.GA13630@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu> <4AA6123F.7020704@arcor.de> <20090908101221.GA21533@elte.hu> <4AA634B0.3050302@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA634B0.3050302@arcor.de>
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


* Nikos Chantziaras <realnc@arcor.de> wrote:

> [...] That would mean that you (or anyone else with an interest of 
> tracking this down) would follow the examples given (by me and 
> others, like enabling desktop compositing, firing up mplayer with 
> a video and generally reproducing this using the quite detailed 
> steps I posted as a recipe).

Could you follow up on Frederic's detailed tracing suggestions that 
would give us the source of the latency?

( Also, as per lkml etiquette, please try to keep the Cc: list 
  intact when replying to emails. I missed your first reply
  that you un-Cc:-ed. )

A quick look at the latencytop output suggests a scheduling latency. 
Could you send me the kernel .config that you are using?

	Ingo

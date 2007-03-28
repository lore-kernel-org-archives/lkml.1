Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXC1Sth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXC1Sth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965657AbXC1Stg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:49:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXC1Stg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:49:36 -0400
Date: Wed, 28 Mar 2007 20:48:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Message-ID: <20070328184843.GA17420@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703290237.38777.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> I'm cautiously optimistic that we're at the thin edge of the bugfix 
> wedge now.

hm, how about the questions Mike raised (there were a couple of cases of 
friction between 'the design as documented and announced' and 'the code 
as implemented')? As far as i saw they were still largely unanswered - 
but let me know if they are all answered and addressed:

 http://marc.info/?l=linux-kernel&m=117465220309006&w=2
 http://marc.info/?l=linux-kernel&m=117489673929124&w=2
 http://marc.info/?l=linux-kernel&m=117489831930240&w=2

and the numbers he posted:

 http://marc.info/?l=linux-kernel&m=117448900626028&w=2

his test conclusion was that under CPU load, RSDL (SD) generally does 
not hold up to mainline's interactivity.

	Ingo

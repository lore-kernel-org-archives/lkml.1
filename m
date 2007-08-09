Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbXHIG73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbXHIG73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXHIG7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:59:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652AbXHIG7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:59:20 -0400
Date: Thu, 9 Aug 2007 08:59:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq,
	structtask_struct *p) : decreases overhead when  rq->nr_running == 1
Message-ID: <20070809065916.GB30046@elte.hu>
References: <000501c7da16$838dea40$6501a8c0@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c7da16$838dea40$6501a8c0@earthlink.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mitchell Erblich <erblichs@earthlink.net> wrote:

> First, RT/RR tasks are not deprecated. [...]

I'm confused, do you say this in reference to anything i said? I did not 
say that RR tasks are deprecated and you were top-posting so i cannot 
connect it to anything specific. I only said RR tasks are _rare_:

>> this is a pretty rare codepath because the overwhelming majority of 
>> RT apps uses SCHED_FIFO [...]

and i hope you can see the difference between 'rare' and 'deprecated' 
;-) And i suspect you also missed the last bit of what i wrote:

>> So this is on several levels an uncommon workload and by adding a 
>> check like that we'd increase the codesize. But ... no strong 
>> feelings against this optimization - if you send a proper patch we 
>> can apply it, it certainly makes sense from a logic POV.

and you also missed the first bit it appears:

>> your change is a possible optimization, [...]

so you are banging, with full force, on completely open doors =B-)

	Ingo

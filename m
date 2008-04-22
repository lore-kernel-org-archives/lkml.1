Return-Path: <linux-kernel-owner+w=401wt.eu-S1764176AbYDVTKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764176AbYDVTKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762823AbYDVTJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:09:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYDVTJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:09:57 -0400
Date: Tue, 22 Apr 2008 21:09:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [repost PATCH] Fix SMP alternatives : use mutex instead of
	spinlock, text_poke is sleepable
Message-ID: <20080422190939.GA30045@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal> <20080422214240.33e79a94@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422214240.33e79a94@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> Ingo,
> 
> I see you applied the NX fix. This patch is the other one needed to 
> make CPU hotplug working. Could you apply this, unless Mathieu has 
> something against it?

sure, patch looks sane - applied it and pushed it out. Thanks,

	Ingo

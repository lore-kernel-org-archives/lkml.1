Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZILODa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZILODa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZILODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:03:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZILOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:03:29 -0400
Date: Sat, 12 Sep 2009 16:03:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 0/8] Introducing the "timechart" tool
Message-ID: <20090912140320.GA9292@elte.hu>
References: <20090912130737.2d55adc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912130737.2d55adc0@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> [note: since this is a visualization tool, and lkml doesn't like 
> html email, it's probably better to read the online version at
> 
> http://blog.fenrus.org/?p=5
> 
> in which I also show screenshots of the tool. The following text 
> is the first part of the online introduction]
> 
> Finding out why your Linux computer performs the way it does has 
> been a hard task. Sure, there is Oprofile, and even ???perf??? in 
> recent kernels. There is LatencyTOP to find out where latencies 
> happen.
> 
> But all of these tools are rather limited when the software stack 
> that has the performance issue is more complex than a single 
> program. The tool that comes closest to being useful is 
> `bootchart???, but that has a rather limited resolution.
> 
> To solve this, I have been working on a new tool, called 
> Timechart, that has the objective to show on a system level what 
> is going on, at various levels of detail. In fact. one of the 
> design ideas behind timechart is that the output should be 
> ???infinitely zoomable???; that is, if you want to know more 
> details about something, you should be able to zoom in to get 
> these details. The rest of this blog post describes some aspects 
> of timechart, using real life examples and screenshots. However, 
> it is really hard to show the power of timechart on such a static 
> page, to get a real feeling of what timechart can show you really 
> ought to try it out yourself.....

Nice! 'perf timechart' is IMO a really intuitive way to visualize 
perf record output.

Text output goes only so far - patterns of scheduling (and patterns 
of bad behavior) are a lot easier to notice in SVGs.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZHYJGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZHYJGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZHYJGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:06:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZHYJGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:06:04 -0400
Date: Tue, 25 Aug 2009 11:05:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090825090558.GC14003@elte.hu>
References: <4A9214E3.2070807@cn.fujitsu.com> <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com> <1251097012.7538.123.camel@twins> <20090824092455.GA25267@elte.hu> <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com> <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com> <1251182405.7538.1050.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251182405.7538.1050.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Ah, my bad, I was thikning tracepoint_probe_register() was the 
> thing that registered the tracepoint itself, not the callback.
> 
> Ok, then what's the problem?, don't do modules that consume their 
> own tracepoints, seems simple enough.

is this a reasonable restriction? I dont see any reason why the act 
of defining and providing a tracepoint should be exclusive of the 
ability to make use of it.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZIGQtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZIGQtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZIGQtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:49:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZIGQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:49:10 -0400
Date: Mon, 7 Sep 2009 18:48:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
Message-ID: <20090907164852.GA6485@elte.hu>
References: <4AA4C04D.1050201@cn.fujitsu.com> <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252341871.7959.37.camel@laptop>
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

> On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
> > Allow to set profile filter via ioctl.
> 
> Hrm,.. not at all sure about this.. what are the ABI implications?

I think the ABI should be fine if it's always a sub-set of C syntax. 
That would be C expressions initially. Hm?

	Ingo

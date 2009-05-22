Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZEVIZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZEVIZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZEVIZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:25:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZEVIZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:25:42 -0400
Date: Fri, 22 May 2009 10:25:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090522082531.GA5993@elte.hu>
References: <4A14FDFE.2080402@cn.fujitsu.com> <alpine.DEB.2.00.0905210915080.4632@gandalf.stny.rr.com> <20090522080144.GB11438@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522080144.GB11438@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


note, this patch fails -tip testing:

kernel/built-in.o: In function `ftrace_event_enable_disable':
trace_events.c:(.text+0x6cf7a): undefined reference to `tracing_stop_cmdline_record'
trace_events.c:(.text+0x6cf91): undefined reference to `tracing_start_cmdline_record'

	Ingo

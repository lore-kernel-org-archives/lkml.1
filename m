Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZHaItl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZHaItl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZHaItk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:49:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZHaItj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:49:39 -0400
Date: Mon, 31 Aug 2009 10:49:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
	TRACE_EVENT
Message-ID: <20090831084922.GB25811@elte.hu>
References: <4A9B6AA7.5020508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B6AA7.5020508@cn.fujitsu.com>
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


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
>   like below:

I think as long as it does not touch tracing infrastructure (which 
your patches dont do in their current form) this should be 
done/merged via the networking tree.

[ There might be some small collisions in define_trace.h (because
  these tracepoints move from legacy to new-style TRACE_EVENT() 
  form) but that's OK. ]

	Ingo

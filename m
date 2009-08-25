Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZHYGpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZHYGpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZHYGpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:45:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbZHYGpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:45:54 -0400
Message-ID: <4A938882.4090405@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 14:45:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_evetns: fix napi's tracepoint
References: <4A937EF5.4040505@cn.fujitsu.com>
In-Reply-To: <4A937EF5.4040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> Currently, the napi's tracepoint works will is depend on
> "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> like below:
> 
> #include <trace/events/skb.h>    // include define_trace.h
> #include <trace/events/napi.h>
> 
> there have error, if we remove "#include <trace/events/skb.h>"
> or include napi.h in the front of include skb.h, It should
> depend on the definiens in include/linux/tracepoint.h and we
> can remove the "DECLARE_TRACE" definiens in
> include/trace/define_trace.h, because "TRACE_EVENT" not use it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Sorry for forget to CC David Miller and netdev@vger.kernel.org, also
mistype the title: trace_evetns -> trace_events, please ignore this mail
and I'll resend it soon

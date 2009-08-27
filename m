Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbZH0KuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbZH0KuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZH0KuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:50:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56974 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZH0KuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:50:11 -0400
Message-ID: <4A9664C2.3000004@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 18:49:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/events: convert NAPI's tracepoint and fix
 DEFINE_TRACE_FN
References: <4A96635C.9070404@cn.fujitsu.com>
In-Reply-To: <4A96635C.9070404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-150567-139010-110549-110581
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> References: <4A966288.8020402@cn.fujitsu.com>
> In-Reply-To: <4A966288.8020402@cn.fujitsu.com>
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 7bit
> 

It's look like my mail client has some problems, I'll check it and resend
this mail. Sorry!

Thanks,
Xiao

> - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
>   like below:
> 
>    sshd-2503  [000]    71.920846: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
>    sshd-2503  [000]    72.020291: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
>    sshd-2503  [000]    72.020418: napi_poll: ifname=eth0 state=NAPI_STATE_SCHED weigth=16 poll=pcnet32_poll
> 
> - Remove the "DECLARE_TRACE" definiens in include/trace/define_trace.h,
>   because TRACE_EVENT not use it
> 
> - Undef DEFINE_TRACE_FN after TRACE_EVENT/TRACE_EVENT_FN expanded,
>   then we can include more TRACE_EVENT .h file in one .c file
>   (the .c file has defined CREATE_TRACE_POINTS)
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>


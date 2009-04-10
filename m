Return-Path: <linux-kernel-owner+w=401wt.eu-S938049AbZDJGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938049AbZDJGiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763854AbZDJGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:38:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763689AbZDJGiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:38:08 -0400
Message-ID: <49DEE940.9070209@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 14:37:52 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracepoint: Make kmem tracepoint use TRACE_EVENT
 macro
References: <49DEE68A.5040902@cn.fujitsu.com> <49DEE6DA.80600@cn.fujitsu.com>
In-Reply-To: <49DEE6DA.80600@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei wrote:
> TRACE_EVENT is more unify and generic for define a tracepoint.
> It also add ftrace support for this tracepoint.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/trace/kmem.h              |   39 +-------
>  include/trace/kmem_event_types.h  |  193 +++++++++++++++++++++++++++++++++++++
>  include/trace/trace_event_types.h |    1 +
>  include/trace/trace_events.h      |    1 +
>  4 files changed, 197 insertions(+), 37 deletions(-)
>  create mode 100644 include/trace/kmem_event_types.h
Sorry for notice that this patch must apply on top of skb's TRACE_EVENT patch:
[PATCH] Tracepoint: Make skb tracepoint use TRACE_EVENT macro

Because both patch need to add a line into include/trace/trace_event_types.h
and include/trace/trace_events.h.

Thanks
Zhaolei


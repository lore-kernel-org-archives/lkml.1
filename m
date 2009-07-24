Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZGXAqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZGXAqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZGXAq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZGXAq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:46:29 -0400
Date: Thu, 23 Jul 2009 20:46:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for
 ksym_trace_filter -- v2
In-Reply-To: <4A67E092.3080202@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907232046040.8469@gandalf.stny.rr.com>
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com> <4A67E092.3080202@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jul 2009, Xiao Guangrong wrote:

> It's rather bored to clear symbol one by one in ksym_trace_filter
> file, so, this patch can let ksym_trace_filter file support quick
> clear, we can write "0" to this file, it can clear all symbols
>  
> for example:
>  # cat ksym_trace_filter
>  ksym_filter_head:rw-
>  global_trace:rw-
>  # echo 0 > ksym_trace_filter
>  # cat ksym_trace_filter
>  #
> 
> Changelog v1->v2:
> Add other way to clear all breakpoints by writing NULL or "*:---"
> to ksym_trace_filter file base on K.Prasad's suggestion

Thanks guys, I'll go ahead and queue this up for 32.

-- Steve


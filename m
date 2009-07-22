Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZGVFIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZGVFIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZGVFIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:08:47 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57515 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZGVFIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:08:46 -0400
Date: Wed, 22 Jul 2009 10:36:36 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for
	ksym_trace_filter
Message-ID: <20090722050636.GA9039@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A66869A.9000106@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:25:14AM +0800, Xiao Guangrong wrote:
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

It's nice to have this feature added and the other patches fix issues in
ksym tracer. Can you have this patch add the capability to clear all
breakpoints in one-shot through wild-cards?

Ingo wanted something like "echo "*:---" > ksym_trace_filter". The patch
I sent here: http://lkml.org/lkml/2009/6/20/73 implements the same. You
may want to implement something on those lines.

Thanks,
K.Prasad


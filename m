Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZEFNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZEFNvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZEFNvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:51:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48037 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZEFNvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:51:04 -0400
Date: Wed, 6 May 2009 09:49:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, randy.dunlap@oracle.com
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090506134940.GA3129@redhat.com>
References: <49FFDF9C.7040505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FFDF9C.7040505@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 02:41:32PM +0800, Xiao Guangrong wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> This patch is modified from Mathieu Desnoyers' patch. The original patch
> can be found here: 
> 	http://marc.info/?l=linux-kernel&m=123791201816245&w=2
> This tracepoint can trace the time stamp when softirq action is raised. 
> 
> Changelog for v1 -> v2: 
> 1: Use TRACE_EVENT instead of DEFINE_TRACE
> 2: Move the tracepoint from raise_softirq_irqoff() to
>    __raise_softirq_irqoff()
> 
> Changelog for v2 -> v3: 
> Move the definition of __raise_softifq_irqoff() to .c file when
> CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 

hi,

Could you please add 'docbook' style comments above TRACE_EVENTi()? We
recently added a tracepoint docbook to the -tip and it already contains
an 'irq' chapter, so you just need to add the comments for the raise
softirq tracepoint. Please see: 

http://marc.info/?l=linux-kernel&m=124118471411710&w=2

thanks,

-Jason



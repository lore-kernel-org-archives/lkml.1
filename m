Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab0CKIj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:39:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0CKIj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:39:27 -0500
Subject: Re: [PATCH] perf: export perf_trace_regs and
 perf_arch_fetch_caller_regs
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B989C1B.2090407@cn.fujitsu.com>
References: <4B989C1B.2090407@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Mar 2010 09:39:16 +0100
Message-ID: <1268296756.5279.926.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 15:30 +0800, Xiao Guangrong wrote:
>  #include "trace.h"
>  
>  DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
> +EXPORT_SYMBOL_GPL(perf_trace_regs);

Shouldn't that be:

EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs); ?

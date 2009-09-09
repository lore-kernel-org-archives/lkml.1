Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZIISdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZIISdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZIISdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:33:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZIISdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:33:19 -0400
Subject: Re: [PATCH] tracing: Clean up trace.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <4AA7517C.2070009@cn.fujitsu.com>
References: <4AA7517C.2070009@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 14:33:20 -0400
Message-Id: <1252521200.27001.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 14:55 +0800, Li Zefan wrote:
> - remove some dead code
> - remove @stats from struct tracer
> - move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
>   to kernel/trace/trace_events_filter.c
> 

Li,

Can you break this patch up into two. I would like some of the changes
to go through tip/tracing/core which does not have the hw-breakpoints
code. Could you resend with two patches, one that applies to
tracing/core and the other that applies to tracing/hw-breakpoints.

Thanks,

-- Steve



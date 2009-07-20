Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZGTTbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZGTTbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGTTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:31:29 -0400
Received: from mga07.intel.com ([143.182.124.22]:30870 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751644AbZGTTb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,236,1246863600"; 
   d="scan'208";a="167006624"
Message-ID: <4A64C610.7090406@linux.intel.com>
Date: Mon, 20 Jul 2009 12:31:28 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: Provide iowait counters
References: <4A64B813.1080506@linux.intel.com> <1248117369.23509.33.camel@laptop>
In-Reply-To: <1248117369.23509.33.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> It might be nice to put a tracepoint there as well, now if there was a
> way to specify perf counter attributes in the TRACE_EVENT() magic so
> that we can feed stuff into perf_tpcounter_event().
> 
> TP_perf_addr()  -- defaults to 0 when not specified
> TP_perf_count() -- defaults to 1 when not specified.
> 
> Steve, Frederic, is there any way to make that happen?
> 
> Failing that we could put an actual swcounter in there I suppose.
> 
> That way we could profile applications based on IO-wait, which would be
> cool.

it'd be nice if this was also a perfcounter event, no doubt about that
(I already have some usages in mind).... but that'd be a separate patch.

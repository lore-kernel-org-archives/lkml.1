Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZIRCPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZIRCPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZIRCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:15:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZIRCPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:15:41 -0400
Subject: Re: [PATCH 1/2] tracing: Factorize the events profile accounting
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1253237613-5589-2-git-send-email-fweisbec@gmail.com>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
	 <1253237613-5589-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 17 Sep 2009 22:15:44 -0400
Message-Id: <1253240144.20020.254.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 03:33 +0200, Frederic Weisbecker wrote:
> Factorize the events enabling accounting in a common tracing core
> helper. This reduces the size of the profile_enable() and
> profile_disable() callbacks for each trace events.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/ftrace_event.h       |    4 ++--
>  include/linux/syscalls.h           |   24 ++++++++----------------
>  include/trace/ftrace.h             |   28 ++++++++--------------------
>  kernel/trace/trace_event_profile.c |   20 ++++++++++++++++++--
>  4 files changed, 36 insertions(+), 40 deletions(-)



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438Ab0A1Kdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0A1Kdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172Ab0A1Kds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:33:48 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50771 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0A1Kdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ndpRn0d2olqKZb54PfOfKfTE+ktPNNQf6HTk74VamQhX23Fr0VbDgh18/AVFqCCyhj
         DFmrlLi+ls50XSV9KKF5HAc71BWKYaC8f1iAJ9OHDnlhld0zJaKYlWgQCL9FqUwqDUdz
         p0rASnE2m9ErG84TyMQXA5C0Zo0B/4OCZPI+g=
Date: Thu, 28 Jan 2010 11:33:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2 v2] perf_event: cleanup for event profile
	buffer operation
Message-ID: <20100128103340.GA5074@nowhere>
References: <4B60E92D.9000808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B60E92D.9000808@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:32:29AM +0800, Xiao Guangrong wrote:
> Introduce ftrace_perf_buf_prepare() and ftrace_perf_buf_submit() to
> operate event profile buffer, clean up redundant code
> 
> Changlog v1->v2:
> - Rename function name address Masami and Frederic's suggestion
> - Add __kprobes for ftrace_perf_buf_prepare() and make
>   ftrace_perf_buf_submit() inline address Masami's suggestion
> - Export ftrace_perf_buf_prepare since module will use it
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h       |   18 ++++++-
>  include/trace/ftrace.h             |   48 +++-----------------
>  kernel/trace/trace_event_profile.c |   52 +++++++++++++++++++--
>  kernel/trace/trace_kprobe.c        |   86 ++++-------------------------------
>  kernel/trace/trace_syscalls.c      |   71 ++++-------------------------
>  5 files changed, 88 insertions(+), 187 deletions(-)


I'm queuing these two patches, thanks Xiao!


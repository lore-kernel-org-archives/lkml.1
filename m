Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831Ab0AYPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0AYPfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541Ab0AYPfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:35:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0AYPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:35:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=V_Gd8SginLMA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=1ssURZzmvnyHaDJo1R0A:9 a=T-94BAF4aAjWlWsX31F-RatMn7oA:4 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 6/8] percpu: add __percpu sparse annotations to trace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org
In-Reply-To: <1264432935-10453-7-git-send-email-tj@kernel.org>
References: <1264432935-10453-1-git-send-email-tj@kernel.org>
	 <1264432935-10453-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 25 Jan 2010 10:35:36 -0500
Message-ID: <1264433736.31321.413.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 00:22 +0900, Tejun Heo wrote:
> Add __percpu sparse annotations to trace.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  include/linux/ftrace_event.h         |    4 ++--
>  include/trace/ftrace.h               |    4 ++--
>  kernel/trace/trace_event_profile.c   |   16 ++++++++--------
>  kernel/trace/trace_functions_graph.c |    2 +-
>  kernel/trace/trace_kprobe.c          |    4 ++--
>  kernel/trace/trace_ksym.c            |   10 +++++-----
>  kernel/trace/trace_syscalls.c        |    4 ++--
>  7 files changed, 22 insertions(+), 22 deletions(-)
> 



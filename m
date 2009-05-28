Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbZE1Uzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbZE1Uzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763653AbZE1UzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:55:25 -0400
Received: from www.tglx.de ([62.245.132.106]:44352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764108AbZE1UzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:55:24 -0400
Date: Thu, 28 May 2009 22:54:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] ftrace: add kernel command line function
 filtering
In-Reply-To: <alpine.DEB.2.00.0905281420590.11238@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0905282251590.3397@localhost.localdomain>
References: <alpine.DEB.2.00.0905281420590.11238@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Steven Rostedt wrote:
> ----
>  Documentation/kernel-parameters.txt |   17 ++++++++++++-
>  kernel/trace/ftrace.c               |   42 +++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+), 2 deletions(-)
> ---------------------------
> commit 3481535dc7351d3a45f67d8016bd78fc5c537628
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu May 28 13:37:24 2009 -0400
> 
>     ftrace: add kernel command line function filtering
>     
>     When using ftrace=function on the command line to trace functions
>     on boot up, one can not filter out functions that are commonly called.
>     
>     This patch adds two new ftrace command line commands.
>     
>       ftrace_notrace=function-list
>       ftrace_filter=function-list
>     
>     Where function-list is a comma separated list of functions to filter.
>     The ftrace_notrace will make the functions listed not be included
>     in the function tracing, and ftrace_filter will only trace the functions
>     listed.
>     
>     These two act the same as the debugfs/tracing/set_ftrace_notrace and
>     debugfs/tracing/set_ftrace_filter respectively.
>     
>     The simple glob expressions that are allowed by the filter files can also
>     be used by the command line interface.
>     
>     	ftrace_notrace=rcu*,*lock,*spin*
>     
>     Will not trace any function that starts with rcu, ends with lock, or has
>     the word spin in it.

 That's enough to filter out most of the annoyance during boot
     
>     Note, if the self tests are enabled, they may interfere with the filtering
>     set by the command lines.
>     
>     [ Imact: allow filtering of function tracing at boot up ]

 Is "Imact" an attempt to distract Linus ?

Thanks,

	tglx

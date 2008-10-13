Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYJMAP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYJMAP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 20:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYJMAPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 20:15:20 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:41122 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752048AbYJMAPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 20:15:19 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Message-ID: <48F29310.1030206@sapo.pt>
Date: Mon, 13 Oct 2008 01:15:12 +0100
From: Luis Henriques <henrix@sapo.pt>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt10
References: <1223839814.19319.5.camel@localhost.localdomain>
In-Reply-To: <1223839814.19319.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven Rostedt wrote:
> We are pleased to announce the 2.6.26.6-rt10 tree, which can be
> downloaded from the location:
> 
>   http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> Changes since 2.6.26.5-rt9
> 
>   - ported to 2.6.26.6
> 
>   - rwlock to handle unnested order unlocks (Steven Rostedt)
> 
>   - rwlock update torture test to test unnested unlocks (Steven Rostedt)
> 
>   - remove rt push comment (Gregory Haskins)
> 
>   - rt sched fix to handle dequeue (Gregory Haskins)
> 
>   - PPC: remove duplicate stack trace code (Robert Schwebel)
> 
>   - ARM: ftrace event IRQ call fix (Alexander Pazdnikov)
> 
>   - fair sched not to resched RT tasks (Peter Zijlstra)
> 
>   - ftrace quick stop (Steven Rostedt)
> 
>   - event trace of resched (Steven Rostedt)
> 
> 
> to build a 2.6.26.6-rt10 tree, the following patches should be applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>   http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.6.bz2
>   http://rt.et.redhat.com/download/patch-2.6.26.6-rt10.bz2
> 
> 
> 
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
> 
>   http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
> 
> 
> The broken out patches are also available.
> 
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I found a compilation error while compiling this new version of the rt
pach.  I guess the following line is enough for you to trace the problem:

kernel/trace/trace_events.c:49: error: ‘function_trace_stop’ undeclared
(first use in this function)

It seems that an 'extern int function_trace_stop' is missing somewhere...

Regards,
--
Luis Henriques

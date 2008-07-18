Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbYGRSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbYGRSbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbYGRSba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:31:30 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:62949 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbYGRSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:31:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAPB3gEhMRKxB/2dsb2JhbACBWq4Q
Date: Fri, 18 Jul 2008 14:31:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH ftrace.git] Immedate Values Optimized Jump Fix
Message-ID: <20080718183124.GA31768@Krystal>
References: <20080717031721.GA24504@Krystal> <20080718161523.GY6875@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080718161523.GY6875@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:29:38 up 43 days, 23:10,  4 users,  load average: 0.95, 0.56,
	0.59
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Hi Ingo,
> > 
> > This fix would apply to the ftrace tree which contains the jump-based 
> > immediate values. I don't know if this tree is still under active 
> > development, but I guess that it wouldn't hurt to fix it.
> > 
> > Caused a kernel OOPS when loading the tracepoint probes once in a 
> > while on a 8-way x86_64.
> 
> We've still got tip/tracing/immediates, with these commits from you:
> 
>  $ git-log-line linus.. arch/x86/kernel/immediate.c
>  ee563d6: immediate values: jump liveliness
>  e26875a: Immediate Values - Jump
>  3fc8d03: Immediate Values - x86 Optimization NMI and MCE support
> 
> ... but the topic is stalled right now, due to hpa having had 
> objections. Have those concerns been resolved? (Peter Cc:-ed)
> 
> i'd have applied this fix, but it does not apply. The first chunk seems 
> already be present (in a different form), the second chunk looks much 
> different.
> 
> 	Ingo
> 

Hrm, I've edited directly the immediate values: jump liveliness patches,
which explains why it does not apply. I'll try to unapply/reapply/fold
the patches and see what it gives.

Plus, I've noticed that the "Text Edit Lock" patches are not in the
immediates branch, thus it fails to compile. Immediate values depends on
the Text Edit Lock patches.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

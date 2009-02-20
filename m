Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZBTRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZBTRcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZBTRcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:32:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZBTRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:32:07 -0500
Date: Fri, 20 Feb 2009 12:32:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: allow archs to preform pre and post process
 for code modification
In-Reply-To: <20090220172525.GH24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201231520.13747@gandalf.stny.rr.com>
References: <20090220163846.709775139@goodmis.org> <20090220164045.641080168@goodmis.org> <20090220172525.GH24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +int ftrace_arch_modify_prepare(void);
> > +int ftrace_arch_modify_post_process(void);
> 
> i think it would be clearer to name it:
> 
> extern int ftrace_arch_code_modify_prepare(void);
> extern int ftrace_arch_code_modify_finish(void);
> 
> ?

Sure, I'll write up a patch.

-- Steve


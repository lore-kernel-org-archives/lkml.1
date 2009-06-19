Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZFSDct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZFSDct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZFSDcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:32:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZFSDcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:32:41 -0400
Date: Thu, 18 Jun 2009 23:32:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       bligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 5/7] add syscall tracepoints
In-Reply-To: <4A3B028C.2040902@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906182332011.6890@gandalf.stny.rr.com>
References: <cover.1244837725.git.jbaron@redhat.com> <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com> <20090619021418.GC7903@nowhere> <4A3B028C.2040902@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Jun 2009, Li Zefan wrote:

> Frederic Weisbecker wrote:
> > On Fri, Jun 12, 2009 at 05:24:59PM -0400, Jason Baron wrote:
> >> update FTRACE_SYSCALL_MAX to the current number of syscalls
> >>
> >>
> >> Signed-off-by: Jason Baron <jbaron@redhat.com>
> >>
> >> ---
> >>  arch/x86/include/asm/ftrace.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> >> index bd2c651..d16d195 100644
> >> --- a/arch/x86/include/asm/ftrace.h
> >> +++ b/arch/x86/include/asm/ftrace.h
> >> @@ -30,9 +30,9 @@
> >>  
> >>  /* FIXME: I don't want to stay hardcoded */
> > 
> > 
> > BTW, is there a way to know this size dynamically?
> > Or is there already a hardcoded number of syscalls somewhere
> > in x86?
> > 
> 
> Does this patchset head for .31 or .32? If for .32, then this patch should
> go into .31 I think.

Probably the best to run it through tip for a release. So, yes this patch 
should go to the beginning of the queue so that we can push it to 31 if 
need be.

-- Steve


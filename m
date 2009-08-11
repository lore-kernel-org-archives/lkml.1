Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZHKTkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZHKTkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZHKTkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:40:09 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:57223 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZHKTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:40:08 -0400
Date: Tue, 11 Aug 2009 20:39:35 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090811193935.GA6902@console-pimps.org>
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811110023.GC4938@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 01:00:25PM +0200, Frederic Weisbecker wrote:
> On Mon, Aug 10, 2009 at 04:52:35PM -0400, Jason Baron wrote:
> > update FTRACE_SYSCALL_MAX to the current number of syscalls
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  arch/x86/include/asm/ftrace.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index bd2c651..7113654 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -30,9 +30,9 @@
> >  
> >  /* FIXME: I don't want to stay hardcoded */
> >  #ifdef CONFIG_X86_64
> > -# define FTRACE_SYSCALL_MAX     296
> > +# define FTRACE_SYSCALL_MAX     299
> >  #else
> > -# define FTRACE_SYSCALL_MAX     333
> > +# define FTRACE_SYSCALL_MAX     337
> >  #endif
> 
> 
> I don't remember why we had to use a hardcoded number.
> Is there no way to keep being sync with the current number of
> syscalls? We dwant to avoid patching the kernel each time we
> have a new syscall :-)
> 

On SH we're using (NR_syscalls - 1) to avoid that exact problem.

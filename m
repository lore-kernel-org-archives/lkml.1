Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbZKSLoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbZKSLoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZKSLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:44:11 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:49776 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZKSLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:44:10 -0500
Date: Thu, 19 Nov 2009 12:44:15 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Aristeu Rozanski <aris@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] ftrace: build ftrace.o when CONFIG_FTRACE_SYSCALLS is
 set for s390
Message-ID: <20091119124415.0fd92f4d@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20091119032439.GB13378@elte.hu>
References: <20091118204044.GR3441@redhat.com>
	<20091119032439.GB13378@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 04:24:39 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Aristeu Rozanski <aris@redhat.com> wrote:
> 
> > Trying to build a s390x kernel with CONFIG_FTRACE_SYSCALLS will fail
> > because ftrace.o is not built/linked.
> > 
> > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> > 
> > ---
> >  arch/s390/kernel/Makefile |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- linus-2.6.orig/arch/s390/kernel/Makefile	2009-10-30 17:49:10.000000000 -0400
> > +++ linus-2.6/arch/s390/kernel/Makefile	2009-11-18 15:39:52.000000000 -0500
> > @@ -44,6 +44,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
> >  obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(CONFIG_64BIT),mcount64.o,mcount.o)
> >  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
> >  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
> > +obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
> >  
> >  # Kexec part
> >  S390_KEXEC_OBJS := machine_kexec.o crash.o
> 
> Nice catch. AFAICS the build failure should trigger if DYNAMIC_FTRACE 
> and FUNCTION_GRAPH_TRACER is disabled - and i think it affects current 
> mainline too.
> 
> I've Cc:-ed Martin and Heiko - i think this fix is for the s390 tree.

Yes, I will add that to the s390 tree for the next merge window.
Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYHTNNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYHTNNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYHTNM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:12:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYHTNM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:12:57 -0400
Date: Wed, 20 Aug 2008 09:12:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eran Liberty <liberty@extricom.com>
cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <48ABFD77.6030701@extricom.com>
Message-ID: <alpine.DEB.1.10.0808200911100.13132@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com> <48AAB7FF.4070502@extricom.com> <alpine.DEB.1.10.0808191614380.4957@gandalf.stny.rr.com>
 <48ABFD77.6030701@extricom.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Eran Liberty wrote:

> Steven Rostedt wrote:
> > On Tue, 19 Aug 2008, Eran Liberty wrote:
> > 
> >   
> > > Steven Rostedt wrote:
> > >     
> > > >         
> > > > > Testing tracer sched_switch: PASSED
> > > > > Testing tracer ftrace: PASSED
> > > > > Testing dynamic ftrace: PASSED
> > > > >         
> > 
> > Do you have PREEMPT_TRACER enabled, or any other tracer for that matter?
> > 
> > -- Steve
> >   
> I can see stack trace & context trace, but they are derived from other choices
> (I can not un select them)

Yeah, those are not bad.

> 
> cat .config | grep TRACE
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_STACKTRACE=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_HAVE_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_FTRACE=y
> # CONFIG_SCHED_TRACER is not set
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y

You must not have PREEMPT on, so the PREEMPT_TRACER will not show up.

The reason I asked, is that my PowerBook runs fine without PREEMPT_TRACER 
but is very unstable when I have PREEMPT_TRACER enabled.

-- Steve


> >   
> > > > > Oops: Exception in kernel mode, sig: 11 [#1]
> > > > > Exsw1600
> > > > > Modules linked in:
> > > > > NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
> > > > >             
> > 
> > 
> >   
> 
> 

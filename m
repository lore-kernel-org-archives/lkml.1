Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZCMQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZCMQuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCMQu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:50:29 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:40252 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759102AbZCMQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:50:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugFACMnuklMQW1W/2dsb2JhbACBTs86g34G
Date: Fri, 13 Mar 2009 12:50:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 2/2] tracing/x86: basic implementation of syscall
	tracing for x86-64
Message-ID: <20090313165020.GD3354@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-3-git-send-email-fweisbec@gmail.com> <20090313163207.GA3354@Krystal> <20090313163702.GA9082@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090313163702.GA9082@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:48:16 up 13 days, 13:14,  2 users,  load average: 0.98, 1.05,
	0.82
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> >
> > > Provide the ptrace hooks and arch specific syscall numbers 
> > > to ftrace arch indepedant syscall numbers. For now it only 
> > > supports 4 syscalls to provide an example.
> > > 
> > 
> > Hi Frederic,
> > 
> > I already have the equivalent TIF_KERNEL_TRACE flag in my 
> > LTTng tree added to every Linux architecture. You might want 
> > to re-use this work rather than re-doing this. I don't mind 
> > changing the flag name.
> 
> Yeah. Note that the TIF bits are just one part - there are other 
> bits needed for HAVE_FTRACE_SYSCALLS arch support.
> 
> Also, i'd eventually expect the TIF bits to be converted to a 
> tracehook callback, not spread it to other architectures.
> 

The nice part about the TIF bit is that it permits adding this syscall
tracing feature without increasing the size of the thread_info struct
nor adding any extra tests in entry.S. Does the tracehook callback have
these features ?

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

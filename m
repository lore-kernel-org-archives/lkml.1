Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbZCTTbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbZCTTbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758884AbZCTTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:30:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757689AbZCTTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:30:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ananth@in.ibm.com
X-Fcc: ~/Mail/linus
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 7/9] tracing: kprobe-tracer plugin supports 	arguments
In-Reply-To: Ananth N Mavinakayanahalli's message of  Friday, 20 March 2009 10:11:25 +0530 <20090320044125.GB6398@in.ibm.com>
References: <49C2B4D0.8030904@redhat.com>
	<20090320005135.GC6895@nowhere>
	<49C31021.5020305@redhat.com>
	<20090320044125.GB6398@in.ibm.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090320193030.9D10DFC3AB@magilla.sf.frob.com>
Date: Fri, 20 Mar 2009 12:30:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A better option could be to generalize syscall_get_arguments() to work
> for functions other than just syscalls where pt_regs are available.

The syscall register argument passing conventions are disjoint from the
normal function calling ABI on some machines (x86).  You can't conflate them.


Thanks,
Roland


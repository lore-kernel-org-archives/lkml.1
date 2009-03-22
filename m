Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZCVMSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZCVMSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZCVMSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:18:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZCVMSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:18:22 -0400
Date: Sun, 22 Mar 2009 13:17:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Diego Calleja <diegocg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090322121748.GE19826@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <200903212135.21457.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903212135.21457.diegocg@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Diego Calleja <diegocg@gmail.com> wrote:

> On Sábado 21 Marzo 2009 16:45:01 Ingo Molnar escribió:
> 
> > The main issue i see is that no kernel developer i work with on a 
> > daily basis uses SystemTap - and i work with a lot of people. Yes, i 
> > could perhaps name two or three people from lkml using it, but its 
> > average penetration amongst kernel folks is essentially zero.
> 
> What about userspace developers? People always talks of systemtap 
> as a kernel thing, but my (humble) impression is that kernel 
> hackers don't seem to need it that much (maybe for the same 
> reasons they didn't a kernel debugger ;), but userspace developers 
> do. There're many userspace projects that offer optional compile 
> options to enable dtrace probes (some people like apple even ship 
> executables of python, perl and ruby with probes by default). 
> There're several firefox hackers that switched to dtrace-capable 
> systems just because the dtrace-javascript probes enabled them to 
> debug javashit code in ways they weren't able in linux or windows.
> 
> In my humble opinion a better development environment for linux 
> userspace programmers is way more important than whether kernel 
> hackers like systemtap or not. So maybe the discussion should be 
> less about "does it help kernel hackers?" and more about "does it 
> help userspace hackers?". My 2¢...

Well, i consider kernel development to be just another form of 
software development, so i dont subscribe to the view that it is 
intrinsically different. (Yes, the kernel has many unique aspects - 
but most software projects have unique aspects.)

In terms of development methodology and tools, in fact i claim that 
the kernel workflow and style of development can be applied to most 
user-space software projects with great success.

So ... if a new development tool is apparently not (yet?) suited to 
a very large and sanely developed software project like the Linux 
kernel, i dont take that as an encouraging sign.

Also, there's practical aspects: the kernel is what we know best so 
if we can make it work well for the kernel, hopes are that other 
large projects can use it too. If we _only_ make the tool good for 
non-kernel purposes, who else will fix it for the kernel? The 
icentive to fix it for the kernel will be significantly lower.

	Ingo

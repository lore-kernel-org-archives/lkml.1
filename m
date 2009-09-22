Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZIVLrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZIVLrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZIVLrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:47:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:55329 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756090AbZIVLrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:47:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/OvUxem/rOnb7KKn1S3MzAAhLq1CVa806onbh25/
	9vqSscLn5DZP8J
Subject: Re: mailing list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
In-Reply-To: <4AB8B65F.7030602@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 13:47:21 +0200
Message-Id: <1253620041.13917.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 14:34 +0300, Avi Kivity wrote:
> On 09/22/2009 02:28 PM, Mike Galbraith wrote:
> > On Tue, 2009-09-22 at 12:13 +0300, Avi Kivity wrote:
> >
> >    
> >> $ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
> >>    Error: symbol 'vmx_vcpu_run' not present amongst the samples.
> >>
> >> builtin symbols work.
> >>      
> > Ah.  Did you reboot or unload/load the module between record and
> > annotate time?  There is no support for that at the moment.
> >    
> 
> No.  Still loaded and running.

Hm, must me a problem with parsing then.  If you add -v -v to the
command line it'll spit out debug data.  For vmx_vcpu_run you should see
a line like so if the module was parsed.

new symbol: ffffffffa0065a49 [00000466]: ahci_interrupt, hist: (nil), obj_start: 0x2a49

	-Mike


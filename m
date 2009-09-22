Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZIVJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZIVJNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZIVJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbZIVJNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:13:37 -0400
Message-ID: <4AB89520.2050900@redhat.com>
Date: Tue, 22 Sep 2009 12:13:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
In-Reply-To: <1253132182.20020.242.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2009 11:16 PM, Steven Rostedt wrote:
> What are people's thoughts about creating a linux-trace-users mailing
> list on vger.kernel.org?
>
> This would be a place for users of tracers and even perf. For asking
> questions about how to use the debugfs/tracing directory or the perf
> tool.
>
> This will not be a place for kernel development. Patches for the tracing
> infrastructure should still go through LKML. This will be a place to ask
> how-to questions, or any other kind of help questions.
>
> LKML can be quite intimidating, and it is not a place to ask help
> questions anyway. I think adding a linux-trace-users mailing list would
> be a good idea.
>    

Yes please.  Here's a question to start it off - how to I 'perf 
annotate' a symbol in a module?

$ perf report
# Samples: 68202
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
     84.17%  qemu-system-x86  [kernel]       [k] vmx_vcpu_run    [kvm_intel]
      4.28%  qemu-system-x86  [kernel]       [k] kvm_arch_vcpu_ioctl_run 
[kvm]
      0.88%  qemu-system-x86  [kernel]       [k] add_preempt_count
      0.75%  qemu-system-x86  [kernel]       [k] _spin_unlock_irqrestore
      0.68%  qemu-system-x86  [kernel]       [k] _spin_lock_irq

$ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
  Error: symbol 'vmx_vcpu_run' not present amongst the samples.

builtin symbols work.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZIVL2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZIVL2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZIVL2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:28:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:56987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756015AbZIVL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:28:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0DcgJ7770aay/i8SJsMyShU3/ZfVMgcRnmdDiml
	Szmt6BdaZaUudB
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
In-Reply-To: <4AB89520.2050900@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 13:28:14 +0200
Message-Id: <1253618894.13917.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:13 +0300, Avi Kivity wrote:

> $ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
>   Error: symbol 'vmx_vcpu_run' not present amongst the samples.
> 
> builtin symbols work.

Ah.  Did you reboot or unload/load the module between record and
annotate time?  There is no support for that at the moment.

There has been talk of eventually putting all pertinent data into
perf.data to support remote analysis etc, but as things stand, module
information is only available for the running kernel.

	-Mike


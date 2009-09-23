Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZIWNGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZIWNGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZIWNGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:06:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:50553 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751463AbZIWNGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:06:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/pHWMtDzjpiec4/4LGC529RX/wdjfHYTDxLQnFi0
	/j3kI75SUdgTm+
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4ABA1B75.7040900@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>
	 <4ABA1B75.7040900@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 15:06:54 +0200
Message-Id: <1253711214.7509.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 15:58 +0300, Avi Kivity wrote:

> Not for me.  'perf report', for example, shows
> 
>      63.08%  qemu-system-x86  
> [kernel]                                              [k] packet_exit
>       4.71%  qemu-system-x86  
> [kernel]                                              [k] hpet_next_event
>       4.38%             init  
> [kernel]                                              [k] 
> mwait_idle_with_hints
> 
> While 'perf top' still shows vmx_vcpu_run.

Ok, I'll find a nice repeatable module hitting load I can profile with
top/report and compare results.  Maybe something will fall out.

	-Mike


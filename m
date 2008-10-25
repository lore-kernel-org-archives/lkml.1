Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYJYKvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYJYKvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYJYKvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:51:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:43278 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYJYKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z7yOn6FKM3AGsvspOQ11ELbxg6Z+GJ/lAZ1L0olpH19GmQ50OVUIvDDlpeFfNxdL61
         u41xzvsxvOFncX2bSAACPb+vqBERnE0fJ05X9iQJn5H2/nZQkZIX/0GAqgBLAqfsMEdF
         tmr5g9opkx84pwKQ0+UoXVyca4kcdaRcwoeL4=
Message-ID: <c62985530810250351u40b671afg2fada687ee1d62f4@mail.gmail.com>
Date: Sat, 25 Oct 2008 12:51:39 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH][RFC] ftrace: function oprofiler
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

2008/10/25 Steven Rostedt <rostedt@goodmis.org>:
> # cat /debug/tracing/ftrace_profile | sort -brn | head -20
>   280075  : __rcu_read_unlock+0xb/0xa2
>   280065  : __rcu_read_lock+0x11/0xb3

The rcu function are on top of this profile. May be it's because you use
rcu when you touch your hash table.
Wouldn't be interesting to disable the counter adding for these
functions when they
are used at this time?

> +config FUNCTION_PROFILER
> +       bool "Trace max stack"

Copy-paste error? :-)

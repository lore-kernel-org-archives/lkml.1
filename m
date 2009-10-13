Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbZJMNTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbZJMNTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759849AbZJMNTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:19:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839AbZJMNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:19:02 -0400
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091013070853.GA13175@elte.hu>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
	 <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
	 <1255404309.7113.948.camel@gandalf.stny.rr.com>
	 <20091013070853.GA13175@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 09:17:02 -0400
Message-Id: <1255439822.7113.1541.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 09:08 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> > (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> > 
> > Is not easy. It's basically implementing a C interpreter :-(
> 
> Btw., what i suggested quite some time ago was that we should bind 
> tracepoints by emitting C source code stubs, which tools can then build 
> and link in, using gcc.

Yeah, and I thought about that too. But that kills any chance of running
the trace on one box (non x86) and reading it on another (x86). And that
is one of my goals for this.

-- Steve



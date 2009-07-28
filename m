Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZG1OkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZG1OkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG1OkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:40:12 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:26408 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZG1OkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:40:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, prasad@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090728140459.GA30412@Krystal>
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com>
	 <1248684817.6987.1573.camel@twins> <20090728010349.GB5147@nowhere>
	 <1248765877.6987.2754.camel@twins>  <20090728140459.GA30412@Krystal>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 16:42:42 +0200
Message-Id: <1248792162.6987.3013.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 10:04 -0400, Mathieu Desnoyers wrote:

> As you see, none of these 2 ways to gather trace data allow statistical
> RR. Therefore, having this feature in the low-level API does not seem to
> make sense for tracing.

I'm not asking for it to be available in the low level API. Quite
contrary, I'm saying that the current API is too high level and pretty
useless for perf counters.




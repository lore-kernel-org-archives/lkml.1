Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZHTGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZHTGIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 02:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZHTGIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 02:08:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42429 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZHTGIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 02:08:50 -0400
Date: Thu, 20 Aug 2009 16:05:28 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090820060528.GG21100@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20090820052605.GC26265@balbir.in.ibm.com> <1250747579.8282.110.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250747579.8282.110.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Agreed, the first hunk is dangerous, on the second hunk, I'm not sure
> about the INT_MAX thing, that's a 4s gap per cpu, that might be a tad
> much.

Yeah I somehow missed the fact we read it every timer tick. I was hoping
for an easy fix but I guess we just need to set a reasonable batch size
at runtime.

Anton

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZD2Cb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZD2Cb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 22:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZD2CbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 22:31:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46553 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZD2CbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 22:31:18 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
In-Reply-To: <20090428103701.GE3825@in.ibm.com>
References: <20090428165203.EBD5.A69D9226@jp.fujitsu.com> <20090428103701.GE3825@in.ibm.com>
Message-Id: <20090429110629.4B05.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 11:31:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > BTW, did you observe any real problem with the percpu counter spinlock ?
> > > > 
> > > > No.
> > > > I review percpu_counter() caller recently and it seems stragen usage.
> > > > 
> > > 
> > > I should have phrased the question better ...
> > > 
> > > So have you found any performance degradation with any benchmarks/workloads
> > > on archs which define VIRT_CPU_ACCOUNTING due to percpu_counter spinlock
> > > being taken on every tick ? If the answer is no, don't you think we could
> > > wait before making the kind of change you are proposing ?
> > 
> > maybe, I don't understand your point.
> 
> My point is, let us not make this change if it is not a real problem that
> has been observed on archs which define VIRT_CPU_ACCOUNTING.

It's nice joke. but not constructive.

but another idea and another patch are always welcome.




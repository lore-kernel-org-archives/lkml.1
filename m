Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbZEOP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbZEOP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZEOP6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:58:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37077 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZEOP6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:58:24 -0400
Date: Fri, 15 May 2009 21:28:07 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090515155807.GA25957@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090513165433.GD16373@in.ibm.com> <20090513165724.GA32707@in.ibm.com> <20090515135604.GC16389@elte.hu> <20090515145144.GD13664@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515145144.GD13664@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 11:51:44AM -0300, Arnaldo Carvalho de Melo wrote:
> > hm, is there a reproducer perhaps? Is there some class file i could 
> > run with specific parameters to reproduce it?
> 
> I'll try this with some java benchmarks we have, AMQP related, lets see
> if I can reproduce it.

I tried this with SPECJbb - which I am not at liberty to distribute
unfortunately. I will try and recreate it with volanomark or other open
source benchmarks.

- vatsa

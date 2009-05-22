Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZEVG0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZEVG0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEVG0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:26:04 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44410 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZEVG0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:26:02 -0400
Date: Fri, 22 May 2009 11:55:55 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090522062555.GB16151@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090513165433.GD16373@in.ibm.com> <20090513165724.GA32707@in.ibm.com> <20090515135604.GC16389@elte.hu> <20090515145144.GD13664@ghostprotocols.net> <20090515155807.GA25957@in.ibm.com> <1242404001.32543.100.camel@laptop> <1242409073.32543.187.camel@laptop> <1242419228.32543.360.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242419228.32543.360.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:27:08PM +0200, Peter Zijlstra wrote:
> OK, so the cleanup isn't solid.. I've been poking at things, and below
> is the current state of my tinkering, but it seems to make things
> worse...

I got around to test the latest tip today and my problem has
disappeared. Thanks!

- vatsa

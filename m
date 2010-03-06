Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0CFIgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 03:36:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:53469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752104Ab0CFIgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 03:36:50 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zh0wBf+KzLyFvmMj7ODa8JiVxBLefnf9hFyGLqH
	DwS3ZkWGRAYKO+
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100305184213.922106492@sbs-t61.sc.intel.com>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Sat, 06 Mar 2010 09:36:45 +0100
Message-Id: <1267864605.22645.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_lat_ctx.patch)
> Performance improvements with this patch:
> "lat_ctx -s 0 2" ~22usec (before-this-patch)	~5usec (after-this-patch)

BTW, is your cpu governor kicking into high gear?  That unpatched number
looks like a throttled down cpu to me.  I know on my box, when there are
micro idles, sometimes cores do not throttle up, making for some fairly
crappy numbers.  Q6600 doesn't throttle down far enough to make such a
_huge_ difference though.

	-Mike


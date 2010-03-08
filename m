Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0CHWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:25:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:33562 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab0CHWZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,604,1262592000"; 
   d="scan'208";a="252278188"
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1267820755.6384.85.camel@marge.simson.net>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
	 <1267820755.6384.85.camel@marge.simson.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 08 Mar 2010 14:24:22 -0800
Message-Id: <1268087062.2830.285.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 12:25 -0800, Mike Galbraith wrote:
> On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
> > plain text document attachment (fix_lat_ctx.patch)
> > Performance improvements with this patch:
> > "lat_ctx -s 0 2" ~22usec (before-this-patch)	~5usec (after-this-patch)
> 
> Hm.  On my Q6600 box, it's nowhere near that.

My numbers are based on an atom netbook.

> Calling the waking cpu idle in that case is a mistake.  Just because the
> sync hint was used does not mean there is no gain to be had. 

Ok. I dropped that part in v2 patches that I just posted.

thanks,
suresh


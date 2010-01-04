Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347Ab0ADJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0ADJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934Ab0ADJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:28:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:41089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0ADJ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:28:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,497,1257148800"; 
   d="scan'208";a="584059278"
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262597105.6408.99.camel@laptop>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262597105.6408.99.camel@laptop>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 17:12:44 +0800
Message-Id: <1262596364.22471.110.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 17:25 +0800, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > Author: Lin Ming <ming.m.lin@intel.com>
> > Date:   Mon Jan 4 14:14:50 2010 +0800
> > 
> >     sched: Pass affine target cpu into wake_affine
> >     
> >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> >     instead of current cpu.
> >     But wake_affine still use current cpu to calculate load which is wrong.
> >     
> >     This patch passes affine cpu into wake_affine.
> >     
> 
> Does this at all help with that regression?

No.


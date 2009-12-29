Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZL2Fex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZL2Fex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZL2Few
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:34:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:17521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZL2Few (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:34:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,466,1257148800"; 
   d="scan'208";a="479802088"
Subject: Re: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262064292.6412.30.camel@marge.simson.net>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1262052582.10685.59.camel@minggr.sh.intel.com>
	 <1262064292.6412.30.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 29 Dec 2009 13:19:19 +0800
Message-Id: <1262063959.13697.6.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 13:24 +0800, Mike Galbraith wrote:
> On Tue, 2009-12-29 at 10:09 +0800, Lin Ming wrote:
> > And also no regression if I run tbench with RT scheduler on tulsa
> > machine, as below command,
> > 
> > schedtool -R -p 20 -e tbench_srv &
> > schedtool -R -p 20 -e tbench 32
> 
> Hm, odd.  I'd expect tbench to suffer when run SCHED_RR, and here it
> does, achieving roughly 85% of lowest SCHED_OTHER throughput.

Here is some misunderstanding.
I compared SCHED_RR tbench with 2.6.32 and 2.6.33-rc1 and no regression
found.

For the same kernel, SCHED_RR tbench only achieved ~40% of SCHED_OTHER
throughput.

Lin Ming


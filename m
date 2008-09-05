Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYIEB06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYIEB06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYIEB0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:26:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:11902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYIEB0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="612912193"
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1220519034.8609.206.camel@twins>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 09:26:37 +0800
Message-Id: <1220577997.15719.1.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not help after these 4 patches applied.

Gregory Haskins (4):
     sched: make task_hot() once again use sd->cache_hot_time
     Revert "sched: zap the migration init / cache-hot balancing code"
     Revert "[PATCH] sched: remove cache_hot_time"
     revert "sched: sched_cacheflush is now unused"


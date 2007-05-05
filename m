Return-Path: <linux-kernel-owner+w=401wt.eu-S1423142AbXEEAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423142AbXEEAOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423143AbXEEAOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:14:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:50800 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423142AbXEEAOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="239553156"
Date: Fri, 4 May 2007 17:12:22 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 0/2] Add percpu smp cacheline align section
Message-ID: <20070505001222.GA26142@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This is follow-up for Suresh's runqueue align in smp patch at:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0704.1/0340.html

The patches place all of smp cacheline aligned percpu data into .data.percpu.cacheline_aligned_in_smp. Other percpu data is still in data.percpu section. The patches can reduce cache line access in SMP and reduce alignment gap waste. The patches also define PERCPU macro for vmlinux.lds.S for code clean up.

PATCH 1/2: Define percpu smp cacheline align interface
PATCH 2/2: Call percpu smp cacheline algin interface

Thanks.

-Fenghua 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763063AbYDVR2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763063AbYDVR2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbYDVR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:28:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:21524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbYDVR2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:28:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,695,1199692800"; 
   d="scan'208";a="375399477"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/1] sched: remove unnecessary kzalloc in sched_init_smp
Date: Tue, 22 Apr 2008 10:28:27 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012AF094@orsmsx424.amr.corp.intel.com>
In-Reply-To: <480E1A9A.6070301@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] sched: remove unnecessary kzalloc in sched_init_smp
Thread-Index: AciknVWSRtIYfIspQ/e1GfbniZ21ygAAI3Wg
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>	 <20080405011101.534396000@polaris-admin.engr.sgi.com> <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com> <480E1A9A.6070301@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2008 17:28:31.0313 (UTC) FILETIME=[48CB4C10:01C8A49E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Tony Luck <tony.luck@intel.com>

> For inclusion into sched-devel/latest tree.

Needs to head to Linus tree ... the preceeding patches have already
been merged there and are causing build errors for me.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.sched.orig/kernel/sched.c
+++ linux-2.6.sched/kernel/sched.c
@@ -8028,11 +8028,6 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
-#if defined(CONFIG_NUMA)
-	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
-								GFP_KERNEL);
-	BUG_ON(sched_group_nodes_bycpu == NULL);
-#endif
 	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */

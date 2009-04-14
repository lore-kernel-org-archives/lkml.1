Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZDNRTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZDNRTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZDNRSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:18:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:62467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZDNRSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,186,1239001200"; 
   d="scan'208";a="403075001"
From: "Luck, Tony" <tony.luck@intel.com>
To: "ego@in.ibm.com" <ego@in.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Tue, 14 Apr 2009 10:18:51 -0700
Subject: RE: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Thread-Topic: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Thread-Index: Acm9I3r8ls38e47xTGaqPb+CncIPwQAAWYkg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39B3CF3B4@orsmsx505.amr.corp.intel.com>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
 <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org>
 <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com>
 <20090414000934.GN817@elte.hu> <20090414033936.GA534@in.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA39B3CF29A@orsmsx505.amr.corp.intel.com>
 <20090414170621.GA1733@in.ibm.com>
In-Reply-To: <20090414170621.GA1733@in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-               printk(KERN_CONT " %s (__cpu_power = %d)", str,
+               printk(KERN_CONT " %s", str);
+               if (group->__cpu_power != SCHED_LOAD_SCALE)
+                       printk(KERN_CONT " (__cpu_power = %d)",
                                                group->__cpu_power);

That looks better.

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony

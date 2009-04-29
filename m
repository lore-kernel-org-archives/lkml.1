Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbZD2SZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbZD2SZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZD2SZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:25:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:4208 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZD2SZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,267,1239001200"; 
   d="scan'208";a="137384977"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Wed, 29 Apr 2009 11:25:43 -0700
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnI9cORFokQ9kziS36jObMSJzfcAAAAdIVw
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A6449D@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	 <20090429002930.b786348b.akpm@linux-foundation.org>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63F45@azsmsx501.amr.corp.intel.com>
	 <20090429090706.bc5f462f.akpm@linux-foundation.org>
	 <1241022336.8021.573.camel@laptop>
	 <1241027196.20099.42.camel@think.oraclecorp.com>
 <1241028413.4529.9247.camel@localhost.localdomain>
In-Reply-To: <1241028413.4529.9247.camel@localhost.localdomain>
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

Pallipadi, Venkatesh writes:
>Output of
># grep . /sys/devices/system/cpu/cpu0/cpufreq/*
>can tell us whether P-state software coordination is the reason behind
>excessive resched IPIs. Look for ondemand being the current_governor and
>affected_cpus containing more than one CPU in it.

On these setups, we are disabling frequency scaling at the bios. 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZJVWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZJVWZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZJVWY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:24:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:27106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZJVWYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,608,1249282800"; 
   d="scan'208";a="506346749"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Thu, 22 Oct 2009 15:24:53 -0700
Subject: RE: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Thread-Topic: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Thread-Index: AcpTJuosjC0cd0HZTG67bV3e9Re+ygAP0pEA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E337D94C@orsmsx505.amr.corp.intel.com>
References: <4ADB967A.4080707@suse.com>
 <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz>
 <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz>
 <4ADD48D1.1040701@kernel.org>
 <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de>
 <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org>
 <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de>
 <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com>
 <20091021061109.GA27195@elte.hu> <4ADF2691.7070304@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E337CF79@orsmsx505.amr.corp.intel.com>
 <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de>
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

> Tony, is the change that will eventually have to be made to ia64 pagefault 
> handler too intrusive for -rc6, and should we rather go with my workaround 
> instead, and try to find something proper for 2.6.33?

Using __alloc_percpu() rather than static declaration looks to be
the right fix here.  Not a "workaround".

-Tony

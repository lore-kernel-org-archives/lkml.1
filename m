Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbZGXFH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbZGXFH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZGXFHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:07:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:8375 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZGXFHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:07:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="477594694"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Tejun Heo'" <tj@kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Date: Thu, 23 Jul 2009 22:07:15 -0700
Subject: RE: [RFC PATCH] ia64: convert to dynamic percpu allocator
Thread-Topic: [RFC PATCH] ia64: convert to dynamic percpu allocator
Thread-Index: AcoKUFEtP0jXOrt+TdGyZILeXOha5QBw0mwg
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B0A9115B@orsmsx505.amr.corp.intel.com>
References: <4A65B0AB.5000608@kernel.org>
 <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com>
 <4A663DC7.4060600@kernel.org>
In-Reply-To: <4A663DC7.4060600@kernel.org>
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

>Yu, Fenghua wrote:
>>> This patch is available in the following git tree.
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-ia64
>>
>> Is this patch against the latest linux-next? It's applied cleanly on
>> linux-next. But compilation reports undefined function
>> pcpu_alloc_alloc_info() in both contig.c and discontig.c.
>
>Oh, it's on top of percpu#for-next + 20 patches to implement sparse
>embedding[1].  I think it would be the easiest to fetch the above git
>tree.

After cloning from git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git, kernel built with CONFIG_DISCONTIGMEM=y boots ok.

After pulling from review-ia64, kernel built with CONFIG_DISCONTIGMEM=y can not boot on ia64. After loading kernel and initrd, system hangs and doesn't show anything on serial port.

Thanks.

-Fenghua 

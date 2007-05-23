Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbXEWTKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbXEWTKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXEWTKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:10:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:36310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEWTKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,571,1170662400"; 
   d="scan'208";a="231352001"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Date: Wed, 23 May 2007 12:09:56 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8CF8@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070523185748.GA4072@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Thread-Index: AcedbDnX+z8wlnV3RbeUWIFyt3JPBgAAKo4A
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Ravikiran G Thirumalai" <kiran@scalex86.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <clameter@sgi.com>,
       <rmk@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
       <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>
X-OriginalArrivalTime: 23 May 2007 19:09:57.0145 (UTC) FILETIME=[F3D95090:01C79D6D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Has there been any measurable benefit yet due to tail padding?

We don't have data that tail padding actually helps. It all
depends on what data the linker lays out in the cachelines.

As of now we just want to create the infrastructure (so that
more and more people who need it, can use it).

>It would also be interesting to check the wastage/savings on another
large
>cache architecture like S390 (which has a 256 byte cache line)

S390 folks or others might help get the data. I don't have other
machines
on hand.

Thanks.

-Fenghua

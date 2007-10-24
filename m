Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXJXBTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXJXBTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXJXBTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:19:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:7509 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXJXBTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,321,1188802800"; 
   d="scan'208";a="304285111"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] I/OAT: Add support for version 2 of ioatdma device
Date: Tue, 23 Oct 2007 18:18:54 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C0349A5C8@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071023125613.4e90b764.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] I/OAT: Add support for version 2 of ioatdma device
Thread-Index: AcgVrsYi3Q5eV82ZTm+9zn/q9eEaTAALL3uQ
References: <20071019072024.5057.3665.stgit@localhost.localdomain> <20071023125613.4e90b764.akpm@linux-foundation.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 24 Oct 2007 01:18:56.0233 (UTC) FILETIME=[D8F9CD90:01C815DB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>On Fri, 19 Oct 2007 00:20:25 -0700
>Shannon Nelson <shannon.nelson@intel.com> wrote:
>
>> Add support for version 2 of the ioatdma device.  This device handles
>> the descriptor chain and DCA services slightly differently:
>>  - Instead of moving the dma descriptors between a busy and 
>an idle chain,
>>    this new version uses a single circular chain so that we 
>don't have
>>    rewrite the next_descriptor pointers as we add new 
>requests, and the
>>    device doesn't need to re-read the last descriptor.
>>  - The new device has the DCA tags defined internally 
>instead of needing
>>    them defined statically.
>> 

Andrew,

Thank you for your time and the review comments.  I'll attend to the
details and repost.

sln

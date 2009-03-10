Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZCJRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZCJRcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZCJRcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:32:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:48042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZCJRcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,336,1233561600"; 
   d="scan'208";a="118779032"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Tue, 10 Mar 2009 10:33:31 -0700
Subject: RE: remap_pfn_range() not suitable for physical RAM?
Thread-Topic: remap_pfn_range() not suitable for physical RAM?
Thread-Index: AcmhVvdWyK7bCXS1SdixO/B+IdWCVAATyUkA
Message-ID: <7E82351C108FA840AB1866AC776AEC464FD82A88@orsmsx505.amr.corp.intel.com>
References: <200903042025.46861.frank.mehnert@sun.com>
 <200903100904.22753.frank.mehnert@sun.com>
In-Reply-To: <200903100904.22753.frank.mehnert@sun.com>
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


Frank,

Patch here should eliminate the restriction.
http://marc.info/?l=linux-kernel&m=123664923030126&w=1

Thanks,
Venki
 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Frank Mehnert
>Sent: Tuesday, March 10, 2009 1:04 AM
>To: linux-kernel@vger.kernel.org
>Cc: peterz@infradead.org; Siddha, Suresh B
>Subject: Re: remap_pfn_range() not suitable for physical RAM?
>
>Hi,
>
>sorry for re-posting this message and sorry for addressing you 
>directly.
>Perhaps you can help me again or can you give me a pointer for a proper
>documentation of the various *remap* and *vm_insert* functions:
>
>On Wednesday 04 March 2009, Frank Mehnert wrote:
>> since 2.6.29-rcX it seems to be not allowed anymore to use
>> remap_pfn_range() to remap physical RAM to userland. This restriction
>> applies only if CONFIG_X86_PAT is enabled. It seems that 
>vm_insert_page()
>> does not have this restriction. Am I correct? And what is the reason
>> for this restriction?
>
>Kind regards,
>
>Frank
>-- 
>Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/
>
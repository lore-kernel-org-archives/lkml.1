Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYCYXjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYCYXjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbYCYXi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:38:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:13140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbYCYXi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:38:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,555,1199692800"; 
   d="scan'208";a="223164461"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: pat cpu feature bit setting for known cpus
Date: Tue, 25 Mar 2008 16:38:22 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEC3E1EB@orsmsx423.amr.corp.intel.com>
In-Reply-To: <86802c440803251608v6f09f531x57d9688601cc84fd@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: pat cpu feature bit setting for known cpus
Thread-Index: AciOzoK4zN0hwQkJSJ2tBhOBw4l1NgAAca5w
References: <200803242324.35357.yhlu.kernel@gmail.com> <47E9003B.5010002@zytor.com> <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com> <20080325190851.GC30998@linux-os.sc.intel.com> <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com> <47E9843A.1060702@zytor.com> <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com> <47E98572.704@zytor.com> <86802c440803251608v6f09f531x57d9688601cc84fd@mail.gmail.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
X-OriginalArrivalTime: 25 Mar 2008 23:36:48.0533 (UTC) FILETIME=[18327C50:01C88ED1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Yinghai Lu [mailto:yhlu.kernel@gmail.com] 
>Sent: Tuesday, March 25, 2008 4:09 PM
>To: H. Peter Anvin
>Cc: Ingo Molnar; Pallipadi, Venkatesh; Thomas Gleixner; Andrew 
>Morton; kernel list; Siddha, Suresh B
>Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
>
>On Tue, Mar 25, 2008 at 4:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>  >>
>>  >>  By the way, I want to clarify: I didn't mean it was 
>*intended* as
>>  >>  vendor-lockin, just that it's an undesirable effect of this.
>>  >
>>  > if the PAT works, we may need to trim the memory 
>according to MTRR, right?
>>  >
>>
>>  That doesn't seem like it's specific to PAT?
>
>could page table to  set WRBACK the range that is not covered 
>by MTRR in e820..
>

Trimming of e820 memory is already done by Jesse's patch here
commit 99fc8d424bc5d80
Are you referring to similar thing?

Thanks,
Venki


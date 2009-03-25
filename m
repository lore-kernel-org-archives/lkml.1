Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZCYU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZCYU5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZCYU5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:57:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:24268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZCYU5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,421,1233561600"; 
   d="scan'208";a="500820938"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Andrew Lutomirski'" <amluto@gmail.com>
CC: "'mingo@elte.hu'" <mingo@elte.hu>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'kyle@redhat.com'" <kyle@redhat.com>,
       "'mgross@linux.intel.com'" <mgross@linux.intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
Date: Wed, 25 Mar 2009 13:57:11 -0700
Subject: RE: [patch 0/2] Intel IOMMU Suspend/Resume Support
Thread-Topic: [patch 0/2] Intel IOMMU Suspend/Resume Support
Thread-Index: Acmti72vJlwhe3SwQCm+1nqN8RmzlAAACVJw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8A056D45A@orsmsx505.amr.corp.intel.com>
References: <20090325184548.012018000@intel.com>
 <cb0375e10903251353r367294d1ra00226e030594a32@mail.gmail.com>
In-Reply-To: <cb0375e10903251353r367294d1ra00226e030594a32@mail.gmail.com>
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

>Subject: Re: [patch 0/2] Intel IOMMU Suspend/Resume Support
>
>It looks like patch 1 calls dmar_reenable_qi but patch 2 defines it.
>
>In 2.6.29, there's no dmar_disable_qi that I can see.  Can you respin
>these against something a little less scary than -tip during a merge
>window?  (Especially since -stable will need this soon.)
>

dmar_disable_qi() is defined in tip tree already. This patch set is based on the tip tree. I do have another version of the patch set which is based on 2.6.29.

Ingo,

Do you think which tree this patch set should based on?

Thanks.

-Fenghua


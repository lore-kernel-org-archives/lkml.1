Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYJQCnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYJQCnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYJQCn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:43:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:19835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYJQCn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,428,1220252400"; 
   d="scan'208";a="628153719"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "'Arjan van de Ven'" <arjan@infradead.org>,
       "arun@linux.vnet.ibm.com" <arun@linux.vnet.ibm.com>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Date: Fri, 17 Oct 2008 10:43:24 +0800
Subject: RE: [linux-pm] [RFC PATCH 0/4] timers: Timer migration
Thread-Topic: [linux-pm] [RFC PATCH 0/4] timers: Timer migration
Thread-Index: AckvncFHBHtRnNXUSEWfgD6//WRB7AAYzt1g
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE08A3CEFD3A@pdsmsx502.ccr.corp.intel.com>
References: <20081016114239.GA7641@linux.vnet.ibm.com>
 <20081016073749.4f944a19@infradead.org>
In-Reply-To: <20081016073749.4f944a19@infradead.org>
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

>From: Arjan van de Ven
>Sent: Thursday, October 16, 2008 10:38 PM
>On Thu, 16 Oct 2008 17:12:39 +0530
>>
>>
>> Here's a brief introduction as to why we need timer migration.
>>
>
>as I've said before, for reducing power consumption I don't buy into
>needing this concept....
>
>If you have high frequency timers, you've lost no matter what (and we
>fixed almost all of them in the ecosystem); if you don't have those
>then this patch doesn't really add anything.
>(and the range-hrtimers fixes the intermediate state)
>

Does range-hrtimers work in per-cpu style or globally? If the former
I guess this timer migration may help range-hrtimers feature to
further align rest timers. If globally, then small room remains.

Arun, did you have any actual power improvement data with it?

Thanks,
Kevin

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbZFIODI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbZFIODI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFIOC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:02:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:13251 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZFIOC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="464768221"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Eric Biederman <ebiederm@aristanetworks.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David L Stevens <dlstevens@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Tue, 9 Jun 2009 15:02:27 +0100
Subject: RE: [this_cpu_xx 06/11] Eliminate get/put_cpu
Thread-Topic: [this_cpu_xx 06/11] Eliminate get/put_cpu
Thread-Index: AcnmFKxf3cVzfAm7TeC6MU8EHJ14NwC9h00A
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACCAE1C6@irsmsx504.ger.corp.intel.com>
References: <20090605191819.376530498@gentwo.org>
	 <20090605191851.393195588@gentwo.org>
 <e9c3a7c20906051234m499aefbrd1828a6bbee3caf9@mail.gmail.com>
In-Reply-To: <e9c3a7c20906051234m499aefbrd1828a6bbee3caf9@mail.gmail.com>
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

Dan Williams wrote:
> [ added Maciej to the cc ]

Thanks Dan.

> 
> On Fri, Jun 5, 2009 at 12:18 PM, <cl@linux-foundation.org> wrote:
>> There are cases where we can use this_cpu_ptr and as the result
>> of using this_cpu_ptr() we no longer need to determine the current executing cpu.
>> 
>> In those places no get/put_cpu combination is needed anymore.
>> The local cpu variable can be eliminated.
>> 
>> Preemption still needs to be disabled and enabled since the
>> modifications of the per cpu variables is not atomic. There may
>> be multiple per cpu variables modified and those must all
>> be from the same processor.
>> 
>> cc: Dan Williams <dan.j.williams@intel.com>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
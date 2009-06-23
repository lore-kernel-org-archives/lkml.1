Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZFWTWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZFWTWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZFWTWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:22:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:64289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFWTWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,276,1243839600"; 
   d="scan'208";a="701875990"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "mark.langsdorf@amd.com" <mark.langsdorf@amd.com>
Date: Tue, 23 Jun 2009 12:24:50 -0700
Subject: RE: [PATCH] cpufreq: remove dbs_mutex
Thread-Topic: [PATCH] cpufreq: remove dbs_mutex
Thread-Index: Acn0Nta7QlW4UByPR2asXshnv/2HkQAAULAQ
Message-ID: <7E82351C108FA840AB1866AC776AEC466972B8C5@orsmsx505.amr.corp.intel.com>
References: <4A2835D8.6040903@kernel.org> <20090611105211.GA6760@elte.hu>
 <20090620124817.GA22831@elte.hu> <200906212155.49849.trenn@suse.de>
 <20090623181748.GA31148@elte.hu> <20090623184040.GA6908@elte.hu>
 <1245783116.4534.17466.camel@localhost.localdomain>
 <20090623191418.GA14455@elte.hu>
In-Reply-To: <20090623191418.GA14455@elte.hu>
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

 

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Tuesday, June 23, 2009 12:14 PM
>To: Pallipadi, Venkatesh
>Cc: Thomas Renninger; Dave Jones; Rusty Russell; Linus 
>Torvalds; Yinghai Lu; Avi Kivity; Andrew Morton; Thomas 
>Gleixner; H. Peter Anvin; linux-kernel@vger.kernel.org; 
>cpufreq@vger.kernel.org; mark.langsdorf@amd.com
>Subject: Re: [PATCH] cpufreq: remove dbs_mutex
>
>
>* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
>
>> Mathieu Desnoyers sent a patch earlier that should address 
>this problem.
>> 
>> http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/00331.html
>
>No, that patch has _not_ fixed the regression:
>
>  http://lkml.org/lkml/2009/6/8/563
>

The subsequent failure that Dave saw after that patch seemed to be related to dbs_mutex
http://lkml.org/lkml/2009/6/11/6

That should be be fixed by your original patch.

Thanks,
Venki
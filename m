Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYHKXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYHKXa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYHKXaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:30:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:60766 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYHKXaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:30:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="369827984"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, CIJOML <cijoml@volny.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Date: Mon, 11 Aug 2008 16:29:29 -0700
Subject: RE: PATCH: enable PAT at Pentium M 1.7 GHz
Thread-Topic: PATCH: enable PAT at Pentium M 1.7 GHz
Thread-Index: Acj52UAftAMFGMeXSsGiPksYSzzBZgCLx6Fw
Message-ID: <7E82351C108FA840AB1866AC776AEC460938F2BF@orsmsx505.amr.corp.intel.com>
References: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>
            <489CB25B.9040801@zytor.com>
 <20080809042401.0A7B4B8AE@nebuchadnezzar.smejdil.cz>
 <489D1E28.3020004@zytor.com>
In-Reply-To: <489D1E28.3020004@zytor.com>
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
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of H. Peter Anvin
>Sent: Friday, August 08, 2008 9:34 PM
>To: CIJOML
>Cc: linux-kernel@vger.kernel.org; mingo@redhat.com; tglx@linutronix.de
>Subject: Re: PATCH: enable PAT at Pentium M 1.7 GHz
>
>CIJOML wrote:
>>
>> Well the truth is, that I use this little tweak from
>2.6.26-rc and first
>> cpu having PAT was P3 XEON. And because Intel has backward
>> compatibility, it is safe to use it.
>> I don't have any problem with loosing data or any suspend/resume
>> problems with this.
>
>Sorry, it doesn't work that simple.  There are lots of errata in CPUs,
>and data loss is too critical.
>
>You're of course welcome to run whatever you want on your machine, but
>we have to be more careful.
>

Yes. I am looking through the errata list to enable PAT on known to be good CPUs.

Unfortunately, system works fine with PAT enabled may not mean much right now.
As there are really no significant users of PAT yet. We have PAT WC enabled in
The kernel and PAT APIs exported for the drivers to use. But, unless there are
very many drivers using these PAT APIs we will not really hit the erratas for
the CPUs. Even after that, erratas are like corner cases which does not really
happen very often. So, it is best to go by the published errata list and to
disable PAT where there are known problems.

Thanks,
Venki

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZHGLRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZHGLRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbZHGLRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:17:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:61763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbZHGLRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,341,1246863600"; 
   d="scan'208";a="539399134"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Aug 2009 12:17:49 +0100
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Topic: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Index: AcoXSvdqme4zxLlOT7S/yZM2AuSWLgAAqN/gAACUolA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
 <20090804113555.GA28198@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
 <1249633282.32113.613.camel@twins>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Metzger, Markus T
>Sent: Friday, August 07, 2009 12:58 PM
>To: Ingo Molnar
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org
>Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
>
>
>
>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Friday, August 07, 2009 12:36 PM
>>To: Metzger, Markus T
>>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>>kernel@vger.kernel.org
>>Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
>>
>>
>>this simple test still locks up on latest -tip (which has your
>>latest patch):
>>
>>  titan:~> perf record -f -e branches -c 1 ./loop_1b_instructions
>>
>>on a Core2Duo CPU.
>
>This time, I can't reproduce the problem. I'm running three "perf record" of simple endless
>loop programs in parallel since several minutes on my a-few-days-old -tip plus my patch.


Ingo, what exactly do you mean by "locks up"? Is the kernel hanging or is perf record hanging?

What I'm seeing is that perf record hangs when I try to ^C it. It tries to collect the rest of
the branch trace but trace is generated so fast that it never completes.

regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


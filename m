Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbZHELKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbZHELKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZHELKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:10:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:18765 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZHELKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,328,1246863600"; 
   d="scan'208";a="714089297"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 5 Aug 2009 12:10:26 +0100
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Topic: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Index: AcoU98gcZfPZAe/3R+2NGBTqTkrCLQAxJ0IA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1B964FD@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
 <20090804113555.GA28198@elte.hu>
In-Reply-To: <20090804113555.GA28198@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Tuesday, August 04, 2009 1:36 PM
>To: Peter Zijlstra
>Cc: Metzger, Markus T; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
>
>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Over all looks very nice, some comments below (could be
>> > addressed in a delta patch).
>>
>> ok - thanks guys - i'll test this some and push it out into the
>> perfcounters tree. Will apply the delta patch too once it's done.
>
>the kernel hard-locks if i try to use it:
>
> titan:~/tip/tools/perf> perf record -f -e branches -c 1 ~/hackbench 1
>
>with the attached 64-bit (def-)config, on a Core2 test-box, latest
>-tip.

I can reproduce the problem when tracing kernel branches.

When I trace user-branches or when I disable overflow handling, it seems to work OK.

Please drop the patch. I'll resend the entire patch after I fixed that problem.

thanks and regards,
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


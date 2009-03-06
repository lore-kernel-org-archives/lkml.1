Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZCFPQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZCFPQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZCFPP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:15:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:12619 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZCFPPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:15:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,315,1233561600"; 
   d="scan'208";a="670913502"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Fri, 6 Mar 2009 15:15:46 +0000
Subject: RE: [patch 1/4] x86, bts: add selftest for BTS
Thread-Topic: [patch 1/4] x86, bts: add selftest for BTS
Thread-Index: AcmeaGwa+zwosY/7Sfitizypj3fWUAABZzGQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A5A120A@irsmsx504.ger.corp.intel.com>
References: <20090305161711.A16434@sedona.ch.intel.com>
 <20090306143237.GC21907@elte.hu>
In-Reply-To: <20090306143237.GC21907@elte.hu>
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
>Sent: Friday, March 06, 2009 3:33 PM
>To: Metzger, Markus T


>> +#ifdef CONFIG_X86_DS_SELFTEST
>> +static int ds_selftest_bts_consistency(const struct bts_trace *trace)
>
>Consider putting this into ds_selftest.c instead of adding a
>large #ifdef block to ds.c.


Thanks for your comments.

I will correct the style problems, move this into ds_selftest.c,
and resend the entire series next week.

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


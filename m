Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbZCPOe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbZCPOe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbZCPOeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:34:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:47613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759144AbZCPOeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:34:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,373,1233561600"; 
   d="scan'208";a="673290993"
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
Date: Mon, 16 Mar 2009 14:34:13 +0000
Subject: RE: [patch 1/5] x86, bts: detect size of DS fields
Thread-Topic: [patch 1/5] x86, bts: detect size of DS fields
Thread-Index: Acmjy3bT78K6EN7RT7eSnS4sgJAAnACd9+KQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
 <20090313110357.GC31094@elte.hu>
In-Reply-To: <20090313110357.GC31094@elte.hu>
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
>Sent: Friday, March 13, 2009 12:04 PM
>To: Metzger, Markus T


>Applied your patches to tip:tracing/hw-branch-tracer, thanks
>Markus!
>
>I did a small cleanup patch - see it in this thread.
>
>One detail i noticed:
>
>static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
>
>That PER_CPU indirection should be removed - it's enough to have
>system-wide configuration settings. We dont generally support
>assymetric CPU capabilities in the same system, and the per_cpu
>indirection here slows the code down and obfuscates it.

I will change it to a single configuration for all cpus.


Apologies for the build fail caused by the incomplete renaming
in another patch of that series.
I had the Core i7 support patch on top of my series when I built
the kernel for testing. That patch changes the WARN to check for
the number of pebs counter reset values.

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


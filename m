Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZDAHGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZDAHGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZDAHFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:05:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:24211 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbZDAHFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,305,1235980800"; 
   d="scan'208";a="502548449"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 1 Apr 2009 08:05:42 +0100
Subject: RE: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Thread-Topic: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Thread-Index: AcmyWowOqv5uLg6+SKKeFFVKaU1bQQAPKxww
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D4FDE@irsmsx504.ger.corp.intel.com>
References: <20090331144229.A11867@sedona.ch.intel.com>
 <20090331233958.GA28228@redhat.com>
In-Reply-To: <20090331233958.GA28228@redhat.com>
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
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Wednesday, April 01, 2009 1:40 AM
>To: Metzger, Markus T


>> The first 5 patches apply to .29 with the small preparation patch below.
>
>Tried to review these patches.
>
>As I said, I don't understand ds.c, but I _think_ these changes are good.
>
>I only have a couple of really minor nitpicks...

Thanks for your review!
I will address the nitpicks in separate patches, if that's OK with everyone.


Regarding bisecting, I split the patches to attract reviewers to the smaller
parts rather than scare them off with one big patch.
I hope that the bisecting tool can cope with broken builds between patches.

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


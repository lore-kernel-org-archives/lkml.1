Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZIOMU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZIOMU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZIOMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:20:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:11701 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZIOMUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727084280"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Sep 2009 13:19:36 +0100
Subject: RE: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
Thread-Topic: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
Thread-Index: Aco1+U71bQw8CzapRvyX81Jwoedg+QABBS2g
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC47B0F3A@irsmsx504.ger.corp.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
	 <1253013145.5506.50.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EC47B0E9E@irsmsx504.ger.corp.intel.com>
	 <1253013915.5506.54.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EC47B0EC1@irsmsx504.ger.corp.intel.com>
 <1253014809.5506.62.camel@laptop>
In-Reply-To: <1253014809.5506.62.camel@laptop>
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
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Tuesday, September 15, 2009 1:40 PM


>You could also look at throttling the BTS interrupt when you notice
>you're doing them back-to-back..

There are always ~2k kernel branches between two interrupts.

I would need to detect whether the rest of the kernel has enough
time left. Any idea how I could do this?

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


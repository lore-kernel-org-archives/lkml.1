Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYKUQLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYKUQLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYKUQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:11:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:57239 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752418AbYKUQLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:11:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,644,1220252400"; 
   d="scan'208";a="362794734"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
CC: Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Nov 2008 16:10:59 +0000
Subject: RE: debugctl msr
Thread-Topic: debugctl msr
Thread-Index: AclL7hRqOGq8mGFISlOzoBZwnqhT6QABUVdQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
 <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
In-Reply-To: <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
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
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Freitag, 21. November 2008 16:27
>To: Metzger, Markus T
>Cc: Markus Metzger; Ingo Molnar; Andi Kleen; Andrew Morton; 
>linux-kernel@vger.kernel.org
>Subject: Re: debugctl msr

>The absolute maximum MUST be at buffer+size+1 but the 
>threshold can be anywhere
>between the start of the buffer and buffer+size. You had it set past
>the end of the buffer (at +1),
>therefore PEBS was not generating any interrupts.

The default is cyclic mode, which requires the interrupt threshold
to be outside of the buffer.

A request for interrupt mode should have got you -EOPNOTSUPP.

Absolute max should be one byte beyond the buffer, which
is base + size.


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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZFJNe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZFJNe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZFJNew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:34:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:7483 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZFJNev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,341,1241420400"; 
   d="scan'208";a="698136335"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 10 Jun 2009 14:32:05 +0100
Subject: RE: [tip:tracing/core] x86, bts: reenable ptrace branch trace
 support
Thread-Topic: [tip:tracing/core] x86, bts: reenable ptrace branch trace
 support
Thread-Index: Acnpz4N9aPFGWHo+RB6S5Q5FqIcfkQAAA2Vg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBC651F4@irsmsx504.ger.corp.intel.com>
References: <20090424094448.A30216@sedona.ch.intel.com>
	 <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
	 <1244637843.13761.11786.camel@twins> <20090610125108.GA13506@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC651E2@irsmsx504.ger.corp.intel.com>
 <1244640558.13761.11833.camel@twins>
In-Reply-To: <1244640558.13761.11833.camel@twins>
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
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Wednesday, June 10, 2009 3:29 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; mingo@redhat.com; hpa@zytor.com; linux-kernel@vger.kernel.org; tglx@linutronix.de;
>oleg@redhat.com; linux-tip-commits@vger.kernel.org
>Subject: RE: [tip:tracing/core] x86, bts: reenable ptrace branch trace support
>
>On Wed, 2009-06-10 at 14:22 +0100, Metzger, Markus T wrote:
>>
>> The Debug Store interface is completely in-kernel. It does not expose
>> anything to the outside world.
>>
>> What we expose is a ptrace interface for branch tracing.
>> That this is built on top of Debug Store is completely hidden.
>> The Debug Store interface may be changed without impacting the
>> user-visible part at any time.
>>
>> I do think that a ptrace interface makes sense since debuggers are the
>> targeted users for branch tracing.
>>
>> I don't see why we should not merge the fixes now and then rework the
>> in-kernel parts as needed for supporting PEBS.
>
>Ok, so what is all that account_locked_memory() for?

To allow debuggers (users) to decide how much memory they want to spend
on branch tracing.

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


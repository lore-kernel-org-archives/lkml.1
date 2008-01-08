Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbYAHKRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbYAHKRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYAHKRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:17:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:54843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYAHKRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:17:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,257,1196668800"; 
   d="scan'208";a="251011655"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 1/2] x86, ptrace: add version and last remaining sizeto status command
Date: Tue, 8 Jan 2008 10:17:05 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444012EB6BB@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080108095030.GI27671@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/2] x86, ptrace: add version and last remaining sizeto status command
thread-index: AchR3E+a0UYp23/WT0a1SzWu1+gPJwAAD33w
References: <20080107133346.A11643@sedona.ch.intel.com> <20080108095030.GI27671@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Ulrich Drepper" <drepper@redhat.com>
X-OriginalArrivalTime: 08 Jan 2008 10:17:06.0003 (UTC) FILETIME=[9E92B230:01C851DF]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Dienstag, 8. Januar 2008 10:50

>please dont use shorts. Lets just us bts_size and no version 
>at all, ok? 

OK.

We need to be careful to add the positive and negative flag for new
features. Otherwise, we cannot distinguish between the default and the
absence of that feature.

>and while at it, how about using u32/u64 for the fields (that's how we 

OK.

>expose ABIs, even if we know that 'unsigned int' is always 32-bit on 
>x86), and add support for COMPAT as well?

COMPAT should already work.

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


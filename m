Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYJPHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYJPHNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYJPHND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:13:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:24334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYJPHNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:13:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,422,1220252400"; 
   d="scan'208";a="451999290"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [rfc] x86, bts: improve X86_PTRACE_BTS help text
Date: Thu, 16 Oct 2008 08:12:52 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF554440290A8AA@swsmsx413.ger.corp.intel.com>
In-Reply-To: <ada1vyhc9ik.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [rfc] x86, bts: improve X86_PTRACE_BTS help text
Thread-Index: AckvXHlpN4of0YczQFmvFOK0ZJkVMgAAB8UA
References: <20081015182902.A30726@sedona.ch.intel.com> <ada1vyhc9ik.fsf@cisco.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 16 Oct 2008 07:12:56.0405 (UTC) FILETIME=[9CFD5850:01C92F5E]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Roland Dreier [mailto:rdreier@cisco.com] 
>Sent: Donnerstag, 16. Oktober 2008 08:57
>To: Metzger, Markus T

> >  config X86_DS
[...]
> > +	def_bool X86_PTRACE_BTS
> > +	depends on X86_DEBUGCTLMSR
>
>using def_bool here to get this turned on if X86_PTRACE_BTS is set
>doesn't seem scalable to more uses of X86_DS.  I would have 
>thought that
>having X86_PTRACE_BTS select X86_DS would make more sense.

We do plan other users. Perfmon2, for example, will be using it.

I fail to see the difference between the two models.
In one case, new users would need to select X86_DS.
In the other case, new users would need to extend the def_bool clause of
X86_DS.

The documentation recommended to use select carefuly, that's why I
picked the other one.

If people think that select is clearer, I will change it.


> > +	  This adds a ptrace interface to the hardware's branch 
>trace store.
> > +
> > +	  Debuggers may use it to collect an execution trace of 
>the debugged
> > +	  application in order to answer the question 'how did 
>I get here?'.
> > +	  Debuggers may trace user mode as well as kernel mode.
> > +
> > +	  Say Y unless there is no application development on 
>this machine
> > +	  and you want to save a small amount of code size.
>
>This looks much better -- someone like me could read this and make an
>informed decision about the config option.

Good. I will send a patch if there is no more feedback on the select vs.
def_bool topic today.

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


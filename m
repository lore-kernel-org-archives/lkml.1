Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbZAPQTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbZAPQTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZAPQTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:19:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:13610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765053AbZAPQTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:19:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,277,1231142400"; 
   d="scan'208";a="482255465"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>
Date: Fri, 16 Jan 2009 16:19:25 +0000
Subject: RE: [patch 4/5] x86, ftrace, hw-branch-tracer: reset trace on close
Thread-Topic: [patch 4/5] x86, ftrace, hw-branch-tracer: reset trace on close
Thread-Index: Acl3612ZuKzzr88vRHqNiJzaK8BiyQACf2fw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CDD7BE0@irsmsx504.ger.corp.intel.com>
References: <20090116120153.A30291@sedona.ch.intel.com>
 <1232118090.21980.85.camel@localhost.localdomain>
In-Reply-To: <1232118090.21980.85.camel@localhost.localdomain>
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
>From: Steven Rostedt [mailto:srostedt@redhat.com]
>Sent: Friday, January 16, 2009 4:02 PM
>To: Metzger, Markus T

>On Fri, 2009-01-16 at 12:01 +0100, Markus Metzger wrote:
>> Reset the ftrace buffer on close. Since we use cyclic buffers to store
>> the trace, the trace is not contiguous, anyway. This behaviour should
>> be more natural.
>
>So you want multiple reads of /debug/tracing/trace to return different
>output? Kind of like the trace_pipe? But trace_pipe is a real consumer.

Yes.
The trace chunks are not contiguous (in this version), so it does not make sense to append them.
I don't expect trace_pipe to work with the hw-branch-tracer.


>BTW, can you run your diff with the -p option. This will help in knowing
>which function the change is in. There's some hunks where it is
>ambiguous. If you use quilt, you can add:
>
>  QUILT_DIFF_OPTS='-p'
>
>to you .quiltrc file.

Thanks.

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


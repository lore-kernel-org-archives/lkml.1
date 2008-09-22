Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYIVMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYIVMA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYIVMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:00:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:42130 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbYIVMAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:00:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,446,1217833200"; 
   d="scan'208";a="49683387"
Content-class: urn:content-classes:message
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [patch] x86, ptrace: void dopiness
Date: Mon, 22 Sep 2008 13:00:00 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544402781F00@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080922115058.GB14301@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: void dopiness
Thread-Index: AckcqYzweXdv+LEcTGuJHtBA7WXDIgAAF8Mg
References: <20080919145250.A6000@sedona.ch.intel.com> <20080922115058.GB14301@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <markus.t.metzger@gmail.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, "Roland McGrath" <roland@redhat.com>
X-OriginalArrivalTime: 22 Sep 2008 12:00:00.0925 (UTC) FILETIME=[BDB084D0:01C91CAA]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Montag, 22. September 2008 13:51
>To: Metzger, Markus T
>Cc: markus.t.metzger@gmail.com; linux-kernel@vger.kernel.org; 
>akpm@linux-foundation.org; Roland McGrath
>Subject: Re: [patch] x86, ptrace: void dopiness
>
>
>* Markus Metzger <markus.t.metzger@intel.com> wrote:
>
>> +++ gits.x86/arch/x86/kernel/ptrace.c	2008-09-19 
>13:53:02.%N +0200
>> @@ -738,7 +738,7 @@
>>  		unsigned int sig = 0;
>>  
>>  		/* we ignore the error in case we were not 
>tracing child */
>> -		(void)ds_release_bts(child);
>> +		ds_release_bts(child);
>
>hm, here the cast is OK because we actually ignore the return value.
>
>> @@ -947,7 +947,7 @@
>>  	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
>>  #endif
>>  #ifdef CONFIG_X86_PTRACE_BTS
>> -	(void)ds_release_bts(child);
>> +	ds_release_bts(child);
>
>is it right/intentional here?

The void-cast is intentional in both cases.

I thought it a question of style, i.e. that we don't want void casts
just like we want NULL instead of 0.

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


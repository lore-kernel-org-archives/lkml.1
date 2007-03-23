Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXCWPxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXCWPxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992480AbXCWPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:53:30 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:47438 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992466AbXCWPx3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:53:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21-rc4-mm1
Date: Fri, 23 Mar 2007 11:53:07 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE67D@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-rc4-mm1
Thread-Index: AcdtRvFsD68dMxq8SluuceoUF9X13AAG8p3g
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602B7D3.4030108@shadowen.org> <4602C83B.20608@shadowen.org> <200703231718.20647.kernel@kolivas.org> <460393A3.60502@shadowen.org> <4603C7EC.6030906@shadowen.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Andy Whitcroft" <apw@shadowen.org>, "Con Kolivas" <kernel@kolivas.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Steve Fox" <drfickle@us.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
X-OriginalArrivalTime: 23 Mar 2007 15:53:07.0954 (UTC) FILETIME=[59D30520:01C76D63]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Andy Whitcroft wrote:
> > Con Kolivas wrote:
> >> On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
> >>> Ok, I have yet a third x86_64 machine is is blowing up with the 
> >>> latest
> >>> 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with 
> >>> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix 
> >>> levels so I have just fired off a set of tests across the affected

> >>> machines on that latest hotfix stack plus the RSDL backout and the

> >>> results should be in in the next hour or two.
> >>>
> >>> I think there is a strong correlation between RSDL and these
hangs.  
> >>> Any suggestions as to the next step.
> >> Found a nasty in requeue_task
> >> +	if (list_empty(old_array->queue + old_prio))
> >> +		__clear_bit(old_prio, p->array->prio_bitmap);
> >>
> >> see anything wrong there? I do :P
> >>
> >> I'll queue that up with the other changes pending and hopefully
that 
> >> will fix your bug.
> > 
> > Tests queued with your rdsl-0.33 patch (I am assuming its in there).
> > Will let you know how it looks.
> 
> Hmmm, this is good for the original machine (as was 0.32) but 
> not for either of the other two.  I am seeing panics as below 
> on those two.
> 
> -apw
> 

I don't know if this might help out or even if it is related but I get a
"similar" crash every time using my backported rsdl patch on a 2.6.19.7
kernel.  "Maybie" this type of BUG might be easier to trigger under that
specific kernel?  Here is a picture of the output:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/bug-2.6.19
.7-rsdl-033.jpg.

- vin

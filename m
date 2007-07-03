Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbXGCPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbXGCPhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXGCPhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:37:15 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:40624 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754644AbXGCPhN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:37:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21.5 june 30th to july 1st date hang?
Date: Tue, 3 Jul 2007 11:36:42 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A63@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <87d4z97bks.fsf@pelargir.dolphinics.no>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21.5 june 30th to july 1st date hang?
Thread-Index: Ace9ho6pDTqhZHjSSe+0nOgQ7cb+2AAAFTGQ
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca><20070703135949.GB19565@master.home><87hcol7en2.fsf@pelargir.dolphinics.no><20070703150210.GA31495@master.home> <87d4z97bks.fsf@pelargir.dolphinics.no>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "Florian Attenberger" <valdyn@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Jul 2007 15:36:43.0329 (UTC) FILETIME=[F513AB10:01C7BD87]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Arne Georg Gleditsch
> 
> Florian Attenberger <valdyn@gmail.com> writes:
> > yep, controlled by ntpd.
> > You're right according to
> > ftp://hpiers.obspm.fr/iers/bul/bulc/bulletinc.33
> > that event shouldn't have been there.
> 
> I'm not all that versed in ntp-ish, but it appears that the 
> leap second insertion should be propagated through the ntp protocol.
> Whether the leap second in question came from a ntp server 
> giving out wrong data or from a misinterpretation or bug in 
> ntpd is of course hard to say, but either way turning the 
> clock back is unlikely to reconstruct the circumstances.  An 
> interesting exercise might be to code up a small program to 
> call adjtimex with timex.status |= STA_INS, to see if this 
> can trigger the problem.  (The bogus leap second might be a 
> red herring entirely, of course...)

You are probably right, I did tried to reproduce the problem without
success...

Although it is wierd that it happend only on 2.6.21 kernels... It did
not happend on any of my workstations/servers running either 2.6.18 or
2.6.20.  

Could dynticks be involved?

- vin

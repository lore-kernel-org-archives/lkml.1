Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbXGDBGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbXGDBGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXGDBGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:06:42 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:4910 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754425AbXGDBGl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:06:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21.5 june 30th to july 1st date hang?
Date: Tue, 3 Jul 2007 21:06:10 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A68@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <468AB976.2010806@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21.5 june 30th to july 1st date hang?
Thread-Index: Ace9tZDt02eqt1vUTkyZNxOKLA4u8QAIYfUg
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <20070703135949.GB19565@master.home> <87hcol7en2.fsf@pelargir.dolphinics.no> <20070703150210.GA31495@master.home> <87d4z97bks.fsf@pelargir.dolphinics.no> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Chuck Ebbert" <cebbert@redhat.com>, "Chris Friesen" <cfriesen@nortel.com>
Cc: "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "Florian Attenberger" <valdyn@gmail.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Jul 2007 01:06:11.0537 (UTC) FILETIME=[82EA7410:01C7BDD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chuck Ebbert
> Envoyé : 3 juillet 2007 17:03
> 
> On 07/03/2007 03:28 PM, Chris Friesen wrote:
> > Arne Georg Gleditsch wrote:
> > 
> >> An interesting exercise might be to
> >> code up a small program to call adjtimex with timex.status |= 
> >> STA_INS, to see if this can trigger the problem.
> > 
> > Setting the date to just before midnight June 30 UTC and then running 
> > the following as root triggered the crash on a modified 2.6.10.  
> > Anyone see anything wrong with the code below, or is this a valid 
> > indication of a bug in the leap second code?
> > 
> 
> Fixed:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2
> .6.git;a=commitdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b

Thanx a lot!  This was fast! (beat that closed source!)

- vin


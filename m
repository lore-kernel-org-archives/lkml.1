Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXGCOwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXGCOwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbXGCOwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:52:14 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:37422 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756494AbXGCOwN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:52:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21.5 june 30th to july 1st date hang?
Date: Tue, 3 Jul 2007 10:51:51 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A61@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <468A4994.1060603@anagramm.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21.5 june 30th to july 1st date hang?
Thread-Index: Ace9ct0QvRiAV4xjRQ6ilGpsxz9DHwADUf7A
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468A4994.1060603@anagramm.de>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Uli Luckas" <u.luckas@road.de>,
       "Florian Attenberger" <valdyn@gmail.com>,
       "Arne Georg Gleditsch" <argggh@dolphinics.no>
X-OriginalArrivalTime: 03 Jul 2007 14:51:51.0946 (UTC) FILETIME=[B0E336A0:01C7BD81]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Clemens Koller [mailto:clemens.koller@anagramm.de] 
> Envoyé : 3 juillet 2007 09:05
> 
> Hi, Vincent!
> 
> Fortier,Vincent [Montreal] schrieb:
> > Hi all,
> > 
> > All my servers and workstations running a 2.6.21.5 kernel hanged 
> > exactly when the date shift from june 30th to july 1st.
> > 
> > I could not get anything on any of the 20+ consoles...  All the 
> > systems hanged at around the exact same time... When the date shifted 
> > from June 30th to July 1st in UTC ...?
> > 
> > Any clue any one?
> 
> No problems over here with plain 2.6.21.5 on x686
> 
> You could just reset the date back on one of these machines 
> and check the transition again... and see if it was really 
> the kernel who crashed.... and check your cron configuration.

I tried reverting to 23:50 June 30th and it did not hanged when switching to July 1st.  I've tried it a few times without any problems.  So I deactivated all NTP related jobs, switched the date back to June 30th 23:10 and reboot the system.  Wait and see.

> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Uli Luckas
> 
> Same thing here on two machines with plain vanilla 
> 2.6.21.(3/4), on debian testing & debian unstable.
> 

I am also using Debian... But Sarge 3.1.  There might be a relation there unless somebody comes up having the same problem using another dist.  At least it's not CFS related.

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Arne Georg Gleditsch
> 
> Florian Attenberger <valdyn@gmail.com> writes:
> > there was one 'special' event at that date:
> > syslog.2.gz:Jul  1 01:59:59 master kernel: Clock: inserting leap 
> > second 23:59:60 UTC
> 
> As far as I can tell, no leap second was due to be inserted 
> at 1. of July this year.  Is the year set correctly for this box?
> 

All my server/workstations are in sync using ntp... And yes, the year is set properly on all of them.

Regards,

- vin

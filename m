Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbXJZTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbXJZTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXJZTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:02:13 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:37896 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752913AbXJZTCM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:02:12 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 15:02:12 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8,v2.6.21.7, v2.6.20.20
Date: Fri, 26 Oct 2007 14:56:10 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0B896FC@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20070926111357.GA10655@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8,v2.6.21.7, v2.6.20.20
Thread-Index: AcgALmE2Wh8fw1yISUOMZ41kwaQhOwX0sn4Q
References: <20070926111357.GA10655@elte.hu>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Oct 2007 18:56:11.0255 (UTC) FILETIME=[E0058070:01C81801]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Ingo Molnar
> Envoyé : 26 septembre 2007 07:14
> 
> By popular demand, here is release -v22 of the CFS scheduler. 
> It is a full backport of the latest & greatest 
> sched-devel.git code to v2.6.23-rc8, v2.6.22.8, v2.6.21.7 and 
> v2.6.20.20. The patches can be downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> This is the first time the development version of the 
> scheduler has been fed back into the stable backport series, 
> so there's many changes since
> v20.5:
> 
>  15 files changed, 1103 insertions(+), 840 deletions(-)
> 
> Even if CFS v20.5 worked well for you, please try this 
> release too, with a good focus on interactivity testing - 
> because, unless some major showstopper is found, this 
> codebase is intended for a v2.6.24 upstream merge.
> 
> ( Even a quick, subjective report of: "checked this patch, it didnt
>   crash and it feels like v20.5" or "laggier than v20.5" or "feels
>   better than v20.5" is useful to us and enables us to judge 
> the general
>   direction of interactivity. )
> 
> The changes in v22 consist of lots of mostly small 
> enhancements, speedups, interactivity improvements, debug 
> enhancements and tidy-ups - many of which can be 
> user-visible. (These enhancements have been contributed by 
> many people - see the changelog below and the git tree for 
> detailed credits.)
> 

Better late than never...

Hi Ingo & cie.,

I tested CFS v22 on a 2.6.20.10 and it is working like a charm.  I used to have a few lags once in a while with v20.5 on a 2.6.20.6 kernel but they simply vanished with the v22 (although I'm currenctly mostly testing on etch with xorg 7.1 instead of sarge with xfree 4.3 so this might also have an effect...)

It seems stable enough to put it in operation by next week on all our workstations.

This is great work, thx to all CFS contributors.

- vin




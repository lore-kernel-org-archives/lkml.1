Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbXKSQFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbXKSQFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXKSQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:05:13 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:39351 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754548AbXKSQFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:05:11 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,v2.6.22.13, v2.6.21.7
Date: Mon, 19 Nov 2007 11:04:36 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0B897BE@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071119151756.GA25446@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,v2.6.22.13, v2.6.21.7
Thread-Index: Acgqv3Yvr6QXu4i+RiSp6ufc8Q0WrgABj33Q
References: <20071119151756.GA25446@elte.hu>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Nov 2007 16:04:38.0325 (UTC) FILETIME=[E2DF0650:01C82AC5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Ingo Molnar
> 
> By popular demand, here is release -v24 of the CFS scheduler patch.
> 
> It is a full backport of the latest & greatest scheduler code 
> to v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches 
> can be downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> There's tons of changes since v22 was released:
> 
>     36 files changed, 2359 insertions(+), 1082 deletions(-)
> 
> that's 187 individual commits from 32 authors.
> 
> So even if CFS v22 worked well for you, please try this 
> release too and report regressions (if any).
> 

Hi Ingo,

Thnx a lot for theses backports...

Ran into this while compiling a 2.6.22.13 with CFS v24

  CC      kernel/sched.o
kernel/sched.c: In function 'cpu_to_core_group':
kernel/sched.c:6056: error: 'per_cpu__cpu_sibling_map' undeclared (first
use in this function)
kernel/sched.c:6056: error: (Each undeclared identifier is reported only
once
kernel/sched.c:6056: error: for each function it appears in.)
kernel/sched.c:6056: warning: type defaults to 'int' in declaration of
'type name'
kernel/sched.c:6056: error: invalid type argument of 'unary *'
kernel/sched.c: In function 'build_sched_domains':
kernel/sched.c:6319: error: 'per_cpu__cpu_sibling_map' undeclared (first
use in this function)
kernel/sched.c:6319: warning: type defaults to 'int' in declaration of
'type name'
kernel/sched.c:6319: error: invalid type argument of 'unary *'
kernel/sched.c:6330: warning: type defaults to 'int' in declaration of
'type name'
kernel/sched.c:6330: error: invalid type argument of 'unary *'
make[2]: *** [kernel/sched.o] Error 1
make[1]: *** [kernel] Error 2
make[1]: Leaving directory
`/usr/src/linux-headers-2.6.22.13-cfs-sarge-686-envcan'
make: *** [debian/stamp-build-kernel] Error 2

- vin

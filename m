Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbXGORsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbXGORsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbXGORrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:47:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:4940 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109AbXGORrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,540,1175497200"; 
   d="scan'208";a="250731870"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE:  Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Date: Sun, 15 Jul 2007 10:47:51 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB54194850164B1F6@fmsmsx411.amr.corp.intel.com>
In-Reply-To: A<f7c78t$lqe$1@sea.gmane.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Thread-Index: AcfGl5fHmcIegesMQCiDKZJSY9VoXAAb3WMA
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Jul 2007 17:47:50.0984 (UTC) FILETIME=[43858C80:01C7C708]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 12 July 2007 00:17, Al Boldi wrote:
> 
> > Peter Williams wrote:
> >>
> >> Probably the last one now that CFS is in the main line :-(.
> >
> > What do you mean?  A pluggable scheduler framework is indispensible
even
> in
> > the presence of CFS or SD.
> 
> Indeed, and I hope it gets merged, giving people the chance to test
out
> different schedulers easily, without having to do patching,
de-patching,
> re-patching and blah blah blah.
> 

Yes, such a framework would be invaluable, especially given that
scheduling often has conflicting goals and different workloads have
different requirements. No single solution fits all.

> But somehow I doubt it'll get merged now. My bet is that it won't even
be
> taken into consideration, for the same reasons that ultimately drove
Con
> Kolivas to giving up on development of SD. And if it's so, chances are
> people will get tired of trying to get it merged. :/
> 
> >> A patch for 2.6.22 is available at:
> >>
> >> <http://downloads.sourceforge.net/cpuse/plugsched-6.5.1-for-
> 2.6.22.patch>
> >>
> >> Very Brief Documentation:
> >>
> >> You can select a default scheduler at kernel build time.  If you
wish
> to
> >> boot with a scheduler other than the default it can be selected at
boot
> >> time by adding:
> >>
> >> cpusched=<scheduler>
> >>
> >> to the boot command line where <scheduler> is one of: ingosched,
> >> ingo_ll, nicksched, staircase, spa_no_frills, spa_ws, spa_svr,
spa_ebs
> >> or zaphod.  If you don't change the default when you build the
kernel
> >> the default scheduler will be ingosched (which is the normal
scheduler).
> >
> > Can't PlugSched include CFS and SD?
> 
> If I read the announcement correctly, those are the ones referred to
as
> 'ingosched' and 'staircase' :)
> 
> --
> Giuseppe "Oblomov" Bilotta
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

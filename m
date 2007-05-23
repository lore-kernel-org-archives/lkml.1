Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbXEWLDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbXEWLDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758938AbXEWLC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:02:57 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:32435 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758892AbXEWLC4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:02:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [stable] [patch 00/69] -stable review
Date: Wed, 23 May 2007 07:02:29 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB60D@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [stable] [patch 00/69] -stable review
Thread-Index: Acec67nA1usX4NiMR4Wc78tye8ZhfAAPPp8g
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521222004.GT6291@stusta.de> <46521BFD.7040703@redhat.com> <8E8F647D7835334B985D069AE964A4F7028FE807@ECQCMTLMAIL1.quebec.int.ec.gc.ca> <20070523033651.GC26416@kroah.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 May 2007 11:02:30.0225 (UTC) FILETIME=[DB537C10:01C79D29]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Greg KH [mailto:greg@kroah.com] 
> Envoyé : 22 mai 2007 23:37
> À : Fortier,Vincent [Montreal]
> 
> On Tue, May 22, 2007 at 09:28:34PM -0400, Fortier,Vincent 
> [Montreal] wrote:
> > > -----Message d'origine-----
> > > De : linux-kernel-owner@vger.kernel.org
> > > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chuck 
> > > Ebbert Envoy? : 21 mai 2007 18:24
> > > 
> > > Adrian Bunk wrote:
> > > > On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
> > > >> On Mon, 21 May 2007 12:16:12 -0700 Chris Wright 
> > > >> <chrisw@sous-sol.org> wrote:
> > > >>
> > > >>> This is the start of the stable review cycle for the 2.6.21.2 release.
> > > >> Gee a lot of these are fixing recently-added regressions :( ...
> > > > 
> > > > If only it would fix all of them...
> > > > 
> > > > Michal's list [1] currently contains 51 different regressions in
> > > > 2.6.21 compared to 2.6.20 (12 of them were already reported before
> > > > 2.6.21 was released).
> > > 
> > > Yeah, 2.6.21 seems awfully buggy, and patches to fix many of the 
> > > bugs haven't appeared.
> > > 
> > > Another 2.6.20 update seems to be in order...
> > 
> > Hi,
> > 
> > If there is a new stable 2.6.20 / 2.6.21, would it be 
> possible that they both contain also this patch to keep the 
> same behaviour between 2.6.20 -> 2.6.22 kernels regarding 
> paravirt_ops GPL export?
> > 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=com
> > mit;h=21564fd2a3deb48200b595332f9ed4c9f311f2a7
> 
> Why?  Is there an in-kernel use for that export?

I sincerely dont know... Although:
- * NOTE: CONFIG_PARAVIRT is experimental and the paravirt_ops
- * semantics are subject to change. Hence we only do this
- * internal-only export of this, until it gets sorted out and
- * all lowlevel CPU ops used by modules are separately exported.

Makes me think there was a "good enough" reason to export instead of export GPL and that it "could" be usefull to keep the same behaviour for that same experimental feature under 2.6.20 / 2.6.21.  Although, the "until it gets sorted out" makes me think it might planned to get removed before the end of 2.6.22 

Thnx.

- vin

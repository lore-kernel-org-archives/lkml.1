Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXFSBw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXFSBw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXFSBwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:52:21 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:14124 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757341AbXFSBwV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:52:21 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: How to improve the quality of the kernel?
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 18 Jun 2007 21:51:49 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A11@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to improve the quality of the kernel?
Thread-Index: Acex++ucWNl6rA2gQz6zdST2VtzuwAAEtVJw
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org> <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Natalie Protasevich" <protasnb@gmail.com>,
       "Martin Bligh" <mbligh@mbligh.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jun 2007 01:51:50.0273 (UTC) FILETIME=[67222710:01C7B214]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Natalie Protasevich [mailto:protasnb@gmail.com] 
> Envoyé : 18 juin 2007 18:56
> 
> On 6/18/07, Martin Bligh <mbligh@mbligh.org> wrote:
> > >> > So if you make changes to random-driver.c you can do `git-log 
> > >> > random-driver.c|grep Tested-by" to find people who can test your 
> > >> > changes for you.
> > >>
> > >> You would'nt even need to search in GIT.  Maybie even when ever a 
> > >> patchset is being proposed a mail could be sent to appropriate 
> > >> hardware/or feature pseudo-auto-generated mailing-list?
> > >>
> > >> On lkml I mostly try to follow patches/bugs associated with 
> > >> hardware I use.  Why not try to automate the process and get more testers in?
> > >>
> > >
> > > I think this is an excellent point. One data point could be a field 
> > > in bugzilla to input the hardware information. Simple query can 
> > > select common hardware and platform. So far it's not working when 
> > > hardware is just mentioned in the text part.
> >
> > if it's free text it'll be useless for search ... I suppose we could 
> > do drop-downs for architecture at least? Not sure much beyond that 
> > would work ... *possibly* the common drivers, but I don't think we'd 
> > get enough coverage for it to be of use.
> >
> How about several buckets for model/BIOS version/chipset 
> etc., at least optional, and some will be relevant some not 
> for particular cases. But at least people will make an 
> attempt to collect such data from their system, boards, etc.

How about an easy way to send multiple hardware profiles to your bugzilla user account simultaniously linked to an online pciutils database and/or an hardware list database similar to overclocking web sites and why not even with a link to the git repository when possible?

A some sort of really usefull "send your profile" of RHN that would link the driver with the discovered hardware and add you to appropriate mailing lists to test patches/help reproducing & solving problems/etc.

In the end plenty of statistics and hardware compatibility list could be made.  For example, that would make my life easier knowing what level of compatibility Linux can offer for old HP9000 K-boxes that we still have running at the office and presumably get people to contact to get help?

- vin

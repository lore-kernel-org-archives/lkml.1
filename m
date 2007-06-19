Return-Path: <linux-kernel-owner+w=401wt.eu-S1765499AbXFSC2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765499AbXFSC2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761181AbXFSC1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:27:53 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:33145 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760820AbXFSC1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mc1wkJX/kW9k+0/az0PGrcUhdY6HA7kupr9AnfnLSeRZTcywkNlj8Pf/EYEGuuAYYzc3YfmDigsi83NVUggdVYl3uppwomADT5FaZ0PlzsLczxkmM5Pf0CFzkBAuvhpj47hXVcsUUdCJm1uZf1k3gPVFQCpZrrzXC5OMkYdexV8=
Message-ID: <32209efe0706181927w1f346dd3x33641c054f8100cf@mail.gmail.com>
Date: Mon, 18 Jun 2007 19:27:50 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
Subject: Re: How to improve the quality of the kernel?
Cc: "Martin Bligh" <mbligh@mbligh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
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
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A11@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <20070617115258.1f55b29d.akpm@linux-foundation.org>
	 <200706172349.08813.bzolnier@gmail.com>
	 <4675C083.6080409@s5r6.in-berlin.de>
	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>
	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
	 <46770A22.4020007@mbligh.org>
	 <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0128A11@ecqcmtlmail3.quebec.int.ec.gc.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Fortier,Vincent [Montreal] <Vincent.Fortier1@ec.gc.ca> wrote:
> > -----Message d'origine-----
> > De : Natalie Protasevich [mailto:protasnb@gmail.com]
> > Envoyé : 18 juin 2007 18:56
> >
> > On 6/18/07, Martin Bligh <mbligh@mbligh.org> wrote:
> > > >> > So if you make changes to random-driver.c you can do `git-log
> > > >> > random-driver.c|grep Tested-by" to find people who can test your
> > > >> > changes for you.
> > > >>
> > > >> You would'nt even need to search in GIT.  Maybie even when ever a
> > > >> patchset is being proposed a mail could be sent to appropriate
> > > >> hardware/or feature pseudo-auto-generated mailing-list?
> > > >>
> > > >> On lkml I mostly try to follow patches/bugs associated with
> > > >> hardware I use.  Why not try to automate the process and get more testers in?
> > > >>
> > > >
> > > > I think this is an excellent point. One data point could be a field
> > > > in bugzilla to input the hardware information. Simple query can
> > > > select common hardware and platform. So far it's not working when
> > > > hardware is just mentioned in the text part.
> > >
> > > if it's free text it'll be useless for search ... I suppose we could
> > > do drop-downs for architecture at least? Not sure much beyond that
> > > would work ... *possibly* the common drivers, but I don't think we'd
> > > get enough coverage for it to be of use.
> > >
> > How about several buckets for model/BIOS version/chipset
> > etc., at least optional, and some will be relevant some not
> > for particular cases. But at least people will make an
> > attempt to collect such data from their system, boards, etc.
>
> How about an easy way to send multiple hardware profiles to your bugzilla user account simultaniously linked to an online pciutils database and/or an hardware list database similar to overclocking web sites and why not even with a link to the git repository when possible?
>
> A some sort of really usefull "send your profile" of RHN that would link the driver with the discovered hardware and add you to appropriate mailing lists to test patches/help reproducing & solving problems/etc.
>
> In the end plenty of statistics and hardware compatibility list could be made.  For example, that would make my life easier knowing what level of compatibility Linux can offer for old HP9000 K-boxes that we still have running at the office and presumably get people to contact to get help?

This is definitely something that can be done (and should) - well,
especially having ability search by certain criteria - then all sorts
of statistics and databases can be created.
Everything that helps  to find a way to work on a patch and to test
easier should be done to make bug fixing easier and even possible.
Often times the most knowledgeable people are not able to make quick
fix just because there is no way to reproduce the case or get access
to HW.

--Natalie

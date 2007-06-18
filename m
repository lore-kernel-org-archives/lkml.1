Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXFRW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXFRW4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXFRW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:56:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:39547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588AbXFRW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mofcZqyQB9Gw3cyDFvoem9nCd8Rvgv+l7i18aMuTvHtHM2YRF0D80DRFjf2i1QlujNJT2JRGkinHvh3GLJAAiA1qe74HcSkmh+tIj+/DuwJ9pT+mlVpWOOAz2B/XEzEBX1xVI9TfQbrcKNd8CosKC59RcrJU1Os27+Aecbcczzw=
Message-ID: <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
Date: Mon, 18 Jun 2007 15:56:19 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Martin Bligh" <mbligh@mbligh.org>
Subject: Re: How to improve the quality of the kernel?
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
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
In-Reply-To: <46770A22.4020007@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <200706172053.41806.bzolnier@gmail.com>
	 <20070617115258.1f55b29d.akpm@linux-foundation.org>
	 <200706172349.08813.bzolnier@gmail.com>
	 <4675C083.6080409@s5r6.in-berlin.de>
	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>
	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
	 <46770A22.4020007@mbligh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Martin Bligh <mbligh@mbligh.org> wrote:
> >> > So if you make changes to random-driver.c you can do `git-log
> >> > random-driver.c|grep Tested-by" to find people who can test
> >> > your changes for you.
> >>
> >> You would'nt even need to search in GIT.  Maybie even when ever a
> >> patchset is being proposed a mail could be sent to appropriate
> >> hardware/or feature pseudo-auto-generated mailing-list?
> >>
> >> On lkml I mostly try to follow patches/bugs associated with hardware I
> >> use.  Why not try to automate the process and get more testers in?
> >>
> >
> > I think this is an excellent point. One data point could be a field in
> > bugzilla to input the hardware information. Simple query can select
> > common hardware and platform. So far it's not working when hardware is
> > just mentioned in the text part.
>
> if it's free text it'll be useless for search ... I suppose we could
> do drop-downs for architecture at least? Not sure much beyond that
> would work ... *possibly* the common drivers, but I don't think
> we'd get enough coverage for it to be of use.
>
How about several buckets for model/BIOS version/chipset etc., at
least optional, and some will be relevant some not for particular
cases. But at least people will make an attempt to collect such data
from their system, boards, etc.

--Natalie

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765055AbXFRWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765055AbXFRWbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764888AbXFRWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:31:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:16703 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764140AbXFRWbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tp5+nUO6AAYxaWiBrJY77+zOKlFDtNFjlgYYOgNPLt0N+zSCcYXlDnqjgDYgIzen5w1lSafFIswo+vQCJ+5CWf9DwSnpL5TJKNAzZ4Q4f7+ExsMinfBkVopD0MTcjBhsgb1tkWgzXq2Pti7crs3k6GEymrTiFqoaHszYax8V5lg=
Message-ID: <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
Date: Mon, 18 Jun 2007 15:31:04 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
Subject: Re: How to improve the quality of the kernel?
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
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Fortier,Vincent [Montreal] <Vincent.Fortier1@ec.gc.ca> wrote:
> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de
> > Andrew Morton
> >
> > On Mon, 18 Jun 2007 01:15:15 +0200 Stefan Richter
> > <stefanr@s5r6.in-berlin.de> wrote:
> >
> > > Tested-by
> >
> > Tested-by would be good too.  Because over time, we will
> > generate a list of people who own the relevant hardware and
> > who are prepared to test changes.
>
> Why not include a user-space tool that, when invoked, if you agree to
> send personnal info, sends your hardware vs driver info to a web
> database + your email address (maybie even you .config, etc..) ... In
> case of help for testing new patches/finding a bug/etc.. your email
> could be used by maintainers to ask for help...
>
> > So if you make changes to random-driver.c you can do `git-log
> > random-driver.c|grep Tested-by" to find people who can test
> > your changes for you.
>
> You would'nt even need to search in GIT.  Maybie even when ever a
> patchset is being proposed a mail could be sent to appropriate
> hardware/or feature pseudo-auto-generated mailing-list?
>
> On lkml I mostly try to follow patches/bugs associated with hardware I
> use.  Why not try to automate the process and get more testers in?
>

I think this is an excellent point. One data point could be a field in
bugzilla to input the hardware information. Simple query can select
common hardware and platform. So far it's not working when hardware is
just mentioned in the text part.

--Natalie

> - vin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

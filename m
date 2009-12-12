Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbZLLD0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbZLLD0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbZLLDZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:25:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62349 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbZLLDZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=krKqQ2HbqS9VQzBwtaVsGkCMjjwgA82WOdYznPafCFZcAo3duC5MVBxlLpRa5xz4Sc
         10DHZwVZCCUXqsukfGVKdoUf82xf5kSfKX2urECNTrM9ArklsOeHD62vlTTHkI32OqVC
         AMYk0UM+dOGV2EtTvpXVD+s8oVQaPHFZwBa1c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: david@lang.hm
Subject: Re: [PATCH 00/86] PATA fixes
Date: Sat, 12 Dec 2009 04:23:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032201.55115.bzolnier@gmail.com> <alpine.DEB.2.00.0912111801420.10307@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.0912111801420.10307@asgard.lang.hm>
MIME-Version: 1.0
Message-Id: <200912120423.46712.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009 03:02:43 am david@lang.hm wrote:
> On Thu, 3 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> > On Thursday 03 December 2009 09:39:39 pm Jeff Garzik wrote:
> >> On 12/03/2009 03:26 PM, Bartlomiej Zolnierkiewicz wrote:
> >>> On Thursday 03 December 2009 09:11:19 pm Jeff Garzik wrote:
> >>>> On 12/03/2009 02:45 PM, Bartlomiej Zolnierkiewicz wrote:
> >>>>> On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
> >>>>>> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
> >>>>>>> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
> >>>>>>>> The merge window is upon us, which by strict rules means that anything
> >>>>>>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
> >>>>>>>>
> >>>>>>>> However, bug fixes and the like should definitely be in 2.6.33.
> >>>>>>>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
> >>>>>>>> could go either way.
> >>>>>>
> >>>>>>> If you would like to apply some of my patches to 2.6.33 you are more than
> >>>>>>> welcome to do it.  I can even prepare separate git tree with specific changes
> >>>>>>> to make it easier for you once you tell me which changes you would like to
> >>>>>>> see in it.
> >>>>>>
> >>>>>> OK, great.
> >>>>>>
> >>>>>> Can you prepare a patchset containing only fixes?  Comment-only changes
> >>>>>> are acceptable too.  Trivial changes too, if they are extremely trivial :)
> >>>>>>
> >>>>>> Include nothing that adds features, removes or unifies drivers, etc.
> >>>>>
> >>>>> Since this is pretty high-level description and some changes fall into
> >>>>> many categories at once (i.e. addition of proper PCI Power Management
> >>>>> handling could be considered both as a fix and as a feature) I prepared
> >>>>> a rather conservative set of changes (which means that unfortunately
> >>>>> it misses many enhancements available in my tree):
> >>>>>
> >>>>>> Please do it in standard kernel submit form, which is either
> >>>>>> (a) repost the patches (yes, again) being submitted for 2.6.33, or
> >>>>>> (b) a standard git pull request, which includes shortlog, diffstat, and
> >>>>>> all-in-one diff.
> >>>>>
> >>>>> Thank you for the detailed explanation of the standard kernel submit
> >>>>> form (I wonder how would I know this otherwise :) but the thing is that
> >>>>> at the current moment I'm not submitting anything to the upstream.
> >>>>
> >>>> Ok, that explains my confusion, then.  I had thought you intended to get
> >>>> this stuff upstream, and into users' hands.
> >>>
> >>> Interesting argument but the vast majority of users use distribution kernels
> >>> which are not upstream and I doubt that any self-respecting distribution would
> >>> miss such amount of fixes.
> >>
> >> Interesting argument, but applied across 1000+ developers this is
> >> clearly an unscalable development model for distributions.  Thus,
> >
> > Interesting that you have brought distributions' convenience before
> > non-distribution developers' one.
> 
> and you are leaving those of us who use kernel.org out in the cold 
> (forcing all non-distribution users to go through all the work that Jeff 
> described)

[ ..and you believed it? ;) ]

> I'm not sure who you see as benifiting from this approach.

I'm not the maintainer of the affected code (according to MAINTAINERS
at least PATA code is unmaintained and to add more confusion it has been
in such state forever despite numerous claims of said code being the
'official' one ) so I think that you are barking at the wrong tree here..

Moreover the claim of forcing people to do the work was completely
ridiculous (BTW all the changes happen in my own time) since I did/do
a lot to make review/merge easier for people:

- My tree is based on top of libata tree and stays up-to-date with it.

- All changes have been posted to linux-ide and linux-kernel, and they
  had review concerns addressed already (there was only one real issue,
  Alan has noticed that scc_pata change is unnecessary).

- I'm OK with providing additional branches with only selected changes
  to ease the merging process.

--
Bartlomiej Zolnierkiewicz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZLCVG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZLCVG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZLCVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:06:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62379 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZLCVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OvVTfqI63ZOEuR4IKKrWxN98r44m5MwgP2eOQd1usz7a15lms4PiGBlN+QED6qQ3Sl
         2LTE117pnKsgIRkncxBJnL0DiLXgB+nxZsQE1A0XGg/N5q8Brwczl5cADLqQ26lTBJ0Q
         LhwEl3AyMynopoYTPxKgXXU5Rkvk/PoA9Hr9U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 22:01:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032126.58129.bzolnier@gmail.com> <4B18220B.7010305@garzik.org>
In-Reply-To: <4B18220B.7010305@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032201.55115.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 09:39:39 pm Jeff Garzik wrote:
> On 12/03/2009 03:26 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 09:11:19 pm Jeff Garzik wrote:
> >> On 12/03/2009 02:45 PM, Bartlomiej Zolnierkiewicz wrote:
> >>> On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
> >>>> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
> >>>>> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
> >>>>>> The merge window is upon us, which by strict rules means that anything
> >>>>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
> >>>>>>
> >>>>>> However, bug fixes and the like should definitely be in 2.6.33.
> >>>>>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
> >>>>>> could go either way.
> >>>>
> >>>>> If you would like to apply some of my patches to 2.6.33 you are more than
> >>>>> welcome to do it.  I can even prepare separate git tree with specific changes
> >>>>> to make it easier for you once you tell me which changes you would like to
> >>>>> see in it.
> >>>>
> >>>> OK, great.
> >>>>
> >>>> Can you prepare a patchset containing only fixes?  Comment-only changes
> >>>> are acceptable too.  Trivial changes too, if they are extremely trivial :)
> >>>>
> >>>> Include nothing that adds features, removes or unifies drivers, etc.
> >>>
> >>> Since this is pretty high-level description and some changes fall into
> >>> many categories at once (i.e. addition of proper PCI Power Management
> >>> handling could be considered both as a fix and as a feature) I prepared
> >>> a rather conservative set of changes (which means that unfortunately
> >>> it misses many enhancements available in my tree):
> >>>
> >>>> Please do it in standard kernel submit form, which is either
> >>>> (a) repost the patches (yes, again) being submitted for 2.6.33, or
> >>>> (b) a standard git pull request, which includes shortlog, diffstat, and
> >>>> all-in-one diff.
> >>>
> >>> Thank you for the detailed explanation of the standard kernel submit
> >>> form (I wonder how would I know this otherwise :) but the thing is that
> >>> at the current moment I'm not submitting anything to the upstream.
> >>
> >> Ok, that explains my confusion, then.  I had thought you intended to get
> >> this stuff upstream, and into users' hands.
> >
> > Interesting argument but the vast majority of users use distribution kernels
> > which are not upstream and I doubt that any self-respecting distribution would
> > miss such amount of fixes.
> 
> Interesting argument, but applied across 1000+ developers this is 
> clearly an unscalable development model for distributions.  Thus, 

Interesting that you have brought distributions' convenience before
non-distribution developers' one.

> patches go upstream, and are then distributed widely, to eliminate 
> massive amounts of duplicated work across distributions.
> 
> You are essentially implying that each distribution must
> 
> 	- discover your tree
> 	- look through the mailing list to figure out why each of
> 	  ~80 changes are not upstream
> 	- individually make a decision on each of ~80 changes
> 	- actively track your tree for updates, repeating this process
> 	  over and over again

Not really.

I'm only saying that the upstream is so much hassle to deal with it that
it is up to people wanting to see my changes upstream to do the work on
integrating them upstream if they want to see them in upstream faster.

Fair enough?

> Talk about a lot of unwanted work pushed upon OTHER people, all because 
> you choose to avoid the standard upstream development process.

I'm not forcing any work on anybody and I'm not avoiding the standard
process.  I just find other things to have higher priority than pushing
these changes upstream right now.

> >>> That's it.  While this may sound strange to some people it turns out
> >>> that in practice it is much less hassle for me personally to keep some
> >>> of trees outside of the (sometimes greatly overrated) upstream.
> >>>
> >>> If knowing the above you still would like to include the aforementioned
> >>> set of changes in your libata-dev tree they are at kernel.org now.
> >>
> >> I will go through this batch and cherry-pick.  The build fix is already
> >> in my tree.  Existing kernel practice (and previous comments) indicate
> >> that lists of known issues do not belong in Kconfig.  Will take a look
> >> at the other stuff...
> >
> > Well, you were aware that they were not dropped so you could have easily told
> > me that you specifically don't want this patches in the for-2.6.33 tree..
> 
> At the time you built atang-2.6.33, you were aware that those Kconfig 
> changes were not wanted -at all-.

Why should I remember/care/worry about such details?

> You tell others "I think that there were enough hints in my mail 
> already" then fail to apply this logic to yourself.

You forgot that it was you who have asked me to prepare this tree to
enhance your tree.

--
Bartlomiej Zolnierkiewicz

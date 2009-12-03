Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZLCU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZLCU2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZLCU2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:28:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:54084 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZLCU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=W8eddiWmrwfg23kywl0q/m5l8E/RsO/Q6VoYBTDq2omMK9CabJ2LNf5IqMzOwtdneg
         bH1ITzCJ5jaGhy1oyoWG5CBuWxlJoWG0oAS5ilyU6yDf8CXe5/rbORlbJFrwT4t2tg/Z
         5uTsxc3sI0xENQoyHCY2OaI3aN3oO+3auMV10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 21:26:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032045.48728.bzolnier@gmail.com> <4B181B67.5080503@garzik.org>
In-Reply-To: <4B181B67.5080503@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032126.58129.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 09:11:19 pm Jeff Garzik wrote:
> On 12/03/2009 02:45 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
> >> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
> >>> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
> >>>> The merge window is upon us, which by strict rules means that anything
> >>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
> >>>>
> >>>> However, bug fixes and the like should definitely be in 2.6.33.
> >>>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
> >>>> could go either way.
> >>
> >>> If you would like to apply some of my patches to 2.6.33 you are more than
> >>> welcome to do it.  I can even prepare separate git tree with specific changes
> >>> to make it easier for you once you tell me which changes you would like to
> >>> see in it.
> >>
> >> OK, great.
> >>
> >> Can you prepare a patchset containing only fixes?  Comment-only changes
> >> are acceptable too.  Trivial changes too, if they are extremely trivial :)
> >>
> >> Include nothing that adds features, removes or unifies drivers, etc.
> >
> > Since this is pretty high-level description and some changes fall into
> > many categories at once (i.e. addition of proper PCI Power Management
> > handling could be considered both as a fix and as a feature) I prepared
> > a rather conservative set of changes (which means that unfortunately
> > it misses many enhancements available in my tree):
> >
> >> Please do it in standard kernel submit form, which is either
> >> (a) repost the patches (yes, again) being submitted for 2.6.33, or
> >> (b) a standard git pull request, which includes shortlog, diffstat, and
> >> all-in-one diff.
> >
> > Thank you for the detailed explanation of the standard kernel submit
> > form (I wonder how would I know this otherwise :) but the thing is that
> > at the current moment I'm not submitting anything to the upstream.
> 
> Ok, that explains my confusion, then.  I had thought you intended to get 
> this stuff upstream, and into users' hands.

Interesting argument but the vast majority of users use distribution kernels
which are not upstream and I doubt that any self-respecting distribution would
miss such amount of fixes.

The rest can easily use my tree which follows upstream closely and can be
obtained using a single line git command.

> > That's it.  While this may sound strange to some people it turns out
> > that in practice it is much less hassle for me personally to keep some
> > of trees outside of the (sometimes greatly overrated) upstream.
> >
> > If knowing the above you still would like to include the aforementioned
> > set of changes in your libata-dev tree they are at kernel.org now.
> 
> I will go through this batch and cherry-pick.  The build fix is already 
> in my tree.  Existing kernel practice (and previous comments) indicate 
> that lists of known issues do not belong in Kconfig.  Will take a look 
> at the other stuff...

Well, you were aware that they were not dropped so you could have easily told
me that you specifically don't want this patches in the for-2.6.33 tree..

--
Bartlomiej Zolnierkiewicz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZLCWID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZLCWID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZLCWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:08:03 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46900 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZLCWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:08:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NfFPjE9Hfz1q94iR5gNJ2SWK1QVp5DlXkokC7DjQJUA70AGsM1FI5l2w8UM36vq7K6
         lJxZs3/3eh9HGxhfBRoGNOGP1oL3HnXfpmoDSACgs43R/1ewqZ9WLDGZ+vKwudyFHaYV
         LWf6UrjqhGCN8Lup6SojrHIeRbvhwAAtK47iQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 23:06:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032256.39790.bzolnier@gmail.com> <4B18357C.8070807@garzik.org>
In-Reply-To: <4B18357C.8070807@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032306.52022.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 11:02:36 pm Jeff Garzik wrote:
> On 12/03/2009 04:56 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 10:51:09 pm Jeff Garzik wrote:
> >
> >>>>>          pata_via: clear UDMA transfer mode bit for PIO and MWDMA
> >>>>
> >>>> applied -- even though Alan's comment was correct.  It is standard
> >>>> kernel practice to place cosmetic changes into their own patches,
> >>>> because it is standard kernel practice to break up logically distinct
> >>>> changes.
> >>>
> >>> We are talking about:
> >>>
> >>>    pata_via.c |   19 +++++++++++++------
> >>>    1 file changed, 13 insertions(+), 6 deletions(-)
> >>>
> >>> patch here (http://lkml.org/lkml/2009/11/25/380) and cosmetic change
> >>> is clearly documented in the patch description.
> >>>
> >>>
> >>> Do people really wonder why I find upstream to be too much hassle to
> >>> deal with?
> >>
> >> The thousand other kernel developers seem to be able to split up their
> >> patches, separating out cosmetic changes from functional ones.  It has
> >> clear engineering benefits, and has been standard practice for a decade
> >> or more.
> >>
> >> Why is it such an imposition for your patches to look like everyone
> >> else's?  And by "everyone", I mean all other kernel developers, not just
> >> other ATA developers.
> >>
> >> You seem to consider standard kernel practice a hassle.  Separating out
> >> cosmetic changes is not only a libata practice, it is the norm for the
> >> entire kernel.
> >
> > Indeed.
> >
> >  From 94be9a58d7e683ac3c1df1858a17f09ebade8da0 Mon Sep 17 00:00:00 2001
> > From: Jeff Garzik<jeff@garzik.org>
> > Date: Fri, 16 Jan 2009 10:17:09 -0500
> > Subject: [PATCH] [libata] get-identity ioctl: Fix use of invalid memory pointer
> >   for SAS drivers.
> >
> > Caught by Ke Wei (and team?) at Marvell.
> >
> > Also, move the ata_scsi_ioctl export to libata-scsi.c, as that seems to be the
> > general trend.
> >
> > Acked-by: James Bottomley<James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
> 
> If your point, by posting this patch, is that it includes a ton of 
> gratuitous cosmetic changes, you misread the patch.
> 
> ata_scsi_ioctl() remains in existence; only the callers need to use the 
> new SAS-related ioctl function were updated.  The remainder continued to 
> use ata_scsi_ioctl().

Moving kernel exports around is completely unrelated to a bug fix.

Yes, it is convenient to do it in the same patch and OK with me.

--
Bartlomiej Zolnierkiewicz

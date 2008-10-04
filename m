Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYJDI2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYJDI2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYJDI2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:28:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57163 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYJDI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=wTNQ+p5XCHSJM9gFAG8fvbBUIni0TuW5F6uiO1Si0LMHfu02yVTO4i5HJmeqFr7HWq
         u3Vr/KCetlQzCWfCiZ0jhCQG454b7XT/9AI8pTQS3i9ElOaI8BRgEHVsYKH//4HeaIRU
         fSnRbJFmXVm1EBdOg6RMteSOWpPGmD+4WE4uY=
Date: Sat, 4 Oct 2008 10:28:28 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ide-cd: small drive type print fix
Message-ID: <20081004082827.GA4160@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com> <1222669799-6565-3-git-send-email-petkovbb@gmail.com> <200810031918.15455.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810031918.15455.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 07:18:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday 29 September 2008, Borislav Petkov wrote:
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> applied (though I fail to see "an added value" of this change)

It simply makes the format consistent with the lines below: CD-R/RW - which is
the more common way of enumerating supported media you find in different specs
than DVD-R-RAM, don't you think?

> > ---
> >  drivers/ide/ide-cd.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 9ffce7f..e41b94d 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -1784,7 +1784,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
> >  	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
> >  		printk(KERN_CONT " DVD%s%s",
> >  				 (cdi->mask & CDC_DVD_R) ? "" : "-R",
> > -				 (cdi->mask & CDC_DVD_RAM) ? "" : "-RAM");
> > +				 (cdi->mask & CDC_DVD_RAM) ? "" : "/RAM");
> >  
> >  	if ((cdi->mask & CDC_CD_R) == 0 || (cdi->mask & CDC_CD_RW) == 0)
> >  		printk(KERN_CONT " CD%s%s",

-- 
Regards/Gruss,
    Boris.

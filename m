Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbYBLGA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbYBLGA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYBLGAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:00:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:55691 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYBLGAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=oZqB7B3rmasdrX1YWXE4XD9YBiZAo4hHXt7tfw/E4lgT96b+W8OqSMgGr0BosoQQoDQGqUuWjbGkJeiEYJqCiPGQmGqmKpaGa1KSzZ56gvfW0LCiT3ItYaSsYFoJq15X/axWioGk/Nr3Jyhw4W+mPF8v0lN6tXszMw3vpRiWbjc=
Date: Tue, 12 Feb 2008 06:59:19 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/4] ide: generic packet command representation
Message-ID: <20080212055919.GD2879@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com> <200802120109.24152.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802120109.24152.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 01:09:24AM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> On Monday 11 February 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's the ide_atapi_pc unification series. It all went pretty smoothly along
> > the search & replace line. Using driver-specific members in ide_atapi_pc like
> > idefloppy_callback and idetape_callback is kinda dumb but this approach seemed
> > the fastest versus unnecessary callback function signature change that will
> > touch stuff all over the place. Besides, ide-tape might be gone soon so that
> > would alleviate the problem.
> 
> applied all four patches, thanks!
> 
> > On a different note, i noticed ide-scsi might also need a cleanup similar to the
> > other drivers. It is next on my TODO list in case you don't have anything with a
> > higher prio.
> 
> I was actually hoping that you'll continue unifying ATAPI handling...

yeah, sure. ide-scsi simply will wander down the prio stack pushed by the other
stuff :)

> [ ide-scsi is orphaned and has (probably) unfixable problems (because of having

does this mean it might have a similar to idetape's destiny...?

-- 
Regards/Gruﬂ,
    Boris.

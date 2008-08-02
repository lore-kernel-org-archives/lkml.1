Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYHBRKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYHBRKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYHBRJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:09:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:7434 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbYHBRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JPPRLpXIqhdvAWeoB0VFVZfe+6kzOwhu6qerCUvk6zN0StDKsGrDksQkdFR81sz5wy
         HLIIBtDOtZl+s25Y2nEk/WX08yiJF/YrGd0vrPjD/y4gopg40Z+gEYpJi+2tNVE2BuVf
         Tcl5fbd9CEPqdvDNhUr7Hogz1CSqOOcqAB+rY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: IDE S.M.A.R.T. ioctl errors
Date: Sat, 2 Aug 2008 18:38:55 +0200
User-Agent: KMail/1.9.9
Cc: petkovbb@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080728060133.GA14007@gollum.tnic> <200807281822.05211.bzolnier@gmail.com> <488E405E.4010300@rtr.ca>
In-Reply-To: <488E405E.4010300@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021838.55477.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Mark Lord wrote:
> If we're going to continue to keep drivers/ide on life-support,
> then perhaps one should just add SG_IO::ATA_16 support into it
> and leave the "legacy" ioctls alone.

I was actually hoping that somebody will came with this idea (+ patch)
after we unified all separate taskfile execution code-paths and added
struct ide_taskfile (the code is now much more similiar to libata then
it is to old IDE one).

> I've done this for linux-2.2.xx (really!), and the patch was rather
> tiny indeed -- and that custom kernel now supports all of the fancy
> ioctl() needs of hdparm-8.9 and smartctl.
> 
> Perhaps a similar patch for drivers/ide ?
> 
> Here's my 2.2.xx hack for perusal:
>  http://empeg-hijack.sourceforge.net/patches/relative/v489-v490.patch.gz
> 
> It won't work on current kernels, of course, but perhaps something similar would.

Thanks, your 2.2.x patch proves the idea well but we need something
more similar to the current libata code for 2.6.x (the resulting patch
should be both smaller and the easier to make than old IDE backport).

Bart

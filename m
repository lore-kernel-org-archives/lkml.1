Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYG0Pfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYG0Pfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYG0PfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:35:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:44409 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYG0PfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=teSvno9cxciiGk7eaCO81kGaQCqdz4g8vfMApkXULpgEQ2PGh/Afv+3A0mcqu1GGBw
         nSzYeXuRJaZ3rQFHuA3hVSlWfDImeZeWr1lYIqnQ9Dbsl6WQe2TvpYEHJGV9nNPjtEii
         0u4r/bZ1A7Dr4ry/517AGLDPNldnFkJNLEIrQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] remove <linux/hdreg.h>
Date: Sun, 27 Jul 2008 17:28:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807242137.58606.bzolnier@gmail.com> <200807242211.53655.bzolnier@gmail.com> <20080724202209.GA30634@infradead.org>
In-Reply-To: <20080724202209.GA30634@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807271728.05518.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Christoph Hellwig wrote:
> On Thu, Jul 24, 2008 at 10:11:52PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 24 July 2008, Christoph Hellwig wrote:
> > > On Thu, Jul 24, 2008 at 09:37:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > It has no in-kernel users now and can be removed.
> > > 
> > > But beeing an exported header it has userspace users.  Plese keep it
> > > and just leave the ioctl defintions as need by userspace in it instead
> > > of renaming that part to hdio_ioctls.h.
> > 
> > Agreed w.r.t. to keeping it (the last patch was more of rfc than intended
> > to be commited, sorry that I didn't mark it as such) but what's wrong with
> > moving ioctl definitions to hdio_ioctls.h so we have clean separation of
> > obsoleted userspace-only stuff & userspace/kernel stuff?
> 
> Well, if there was anything kernel-related left in hdreg.h I would
> agree to split it, although I'd prefer to move the kernel part out.
> 
> But given that you kill all the kernel only bits anyway, just leave
> the user interface in hdreg.h even if it's slightly misnamed.

Yep, no need to move it around.  I reworked patchset accordingly.

Thanks,
Bart

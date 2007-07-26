Return-Path: <linux-kernel-owner+w=401wt.eu-S936548AbXGZUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548AbXGZUNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbXGZUN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:13:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761555AbXGZUNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=OwHAmerrag/5rVfqdX+PHbVrj1RrqNz1GKoU5nMJEYoywv1M3/WHJsVTnGa6zsWGWKJmFTYDFnZ4EP25iOLvs4nRA3oAo74bgQxDF6DrK/gIGgHF8d1LVOga78w55WGkRzpqN9zGMOv8ihYhMbhAcN768jJ6cEq3xOD9BsR/2Pw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
Date: Thu, 26 Jul 2007 22:11:10 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725213925.2f25906c@the-village.bc.nu> <Pine.LNX.4.60.0707262136530.6614@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0707262136530.6614@poirot.grange>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707262211.10223.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 26 July 2007, Guennadi Liakhovetski wrote:
> On Wed, 25 Jul 2007, Alan Cox wrote:
> 
> > > driver to using platform-device. I got a reply, that it's not worth it now 
> > > that IDE is slowly becoming obsolete, and the pata_platform serves the 
> > > perpose perfectly well. I found this argument reasonable, I had the same 
> > > doubt, just wanted to double-check. So, why do we now need a new legacy 
> > > (a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver 
> > > exists?
> > 
> > We don't *need* it but some people still want to use old IDE and the
> > author was willing to make it neatly compatible so that anything that
> > works with the pata_platform should be able to use the ide_platform
> > driver and vice versa. For the shorter term that can only be a good thing
> > - arch code doesn't need to care about which driver is used, end users
> > can pick and it doesn't end up adding new ties between code and old IDE.
> 
> Ok, thanks for the explanation Alan. So, there's no technical argument, 
> just "being nice to the users", and add a new driver, which we know we'll 

There are some rough edges (especially older and/or rare hardware,
this goes for both cotrollers and devices) that SCSI/libata don't
handle and IDE subsystem do.

> have to remove soon, thus having to persuade its users, who by that time 

Well, we've been hearing "soon" for two years now...

> will get used to it and will not want to invest money into switching to 
> another one...

PS wrt ide_arm.c changes, you really should have cc:ed the author... ;)

Thanks,
Bart

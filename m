Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXDKL2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXDKL2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXDKL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:28:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51157 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752216AbXDKL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:28:54 -0400
Date: Wed, 11 Apr 2007 12:31:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eduard Bloch <edi@gmx.de>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org,
       Jens Axboe <axboe@suse.de>
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070411123102.7dc238d7@the-village.bc.nu>
In-Reply-To: <20070411101245.GA32592@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net>
	<20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
	<20070330134327.GA24030@infradead.org>
	<20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
	<20070330191038.067c346b@the-village.bc.nu>
	<20070331170703.GA8179@rotes76.wohnheim.uni-kl.de>
	<20070331232002.7b478f37@the-village.bc.nu>
	<20070407112131.GA10487@rotes76.wohnheim.uni-kl.de>
	<20070411101245.GA32592@rotes76.wohnheim.uni-kl.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can we do following without having side effects:
> > 
> > open("/dev/sr0",O_EXCL|O_RDWR); /* no matter what it returns */
> > fcntl(..., F_SETLK); /* no matter what it returns */
> > ioctl(f, SCSI_IOCTL_GET_IDLUN, &x);
> > ioctl(f, SCSI_IOCTL_GET_BUS_NUMBER, &jo);
> > 
> > Can you guarantee us that bit? 

open() has side effects. The CD layer allows you to open with O_NDELAY if
you want to avoid them.

> [1] and when we get real critical questions then everything we get is
> radio silence? Very kindly. NOT.

Given the attitude that was shown before be glad I'm even bothering to
reply to this.


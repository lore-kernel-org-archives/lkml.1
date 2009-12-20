Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZLTAf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZLTAf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 19:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZLTAfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 19:35:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54437 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754565AbZLTAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 19:35:23 -0500
Date: Sun, 20 Dec 2009 00:37:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: pata_cmd64x broken in 2.6.33-rc1 on sparc64
Message-ID: <20091220003701.7c5a0257@lxorguk.ukuu.org.uk>
In-Reply-To: <4B2D54AC.3080509@garzik.org>
References: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
	<4B2D54AC.3080509@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > mice: PS/2 mouse device common for all mice
> > ------------[ cut here ]------------
> > WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()

Which version of the cmd64x patch got applied ?

> Does backing out the following commit fix things?
> 
> 	commit d43744390e460dce6626fb8de2c02a24ff650005
> 	Author: Alan Cox <alan@linux.intel.com>
> 	Date:   Mon Nov 30 13:22:54 2009 +0000
> 
> 	    pata_cmd64x: implement serialization as per notes
> 
> Although quite unlikely, commit f0353813afe784330622596ff141e7525ccd99de 
> may also change things.  Try backing that out, if backing out the first 
> commit (d43744...) fails to improve behavior.

I'll take a look at this after new year but it looks like the old version
ended up in the libata tree without the additional fixes, if so its
pretty trivial to sort out (see Bartlomiej response to the original and
the follow up thread plus fixes)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXEZIw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXEZIw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 04:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXEZIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 04:52:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49965 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753705AbXEZIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 04:52:22 -0400
Date: Sat, 26 May 2007 10:52:20 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Olaf Hering <olaf@aepfle.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
In-Reply-To: <1180133119.19517.11.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.62.0705261052110.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
 <20070525112414.GA32336@aepfle.de> <1180133119.19517.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Benjamin Herrenschmidt wrote:
> On Fri, 2007-05-25 at 13:24 +0200, Olaf Hering wrote:
> > On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:
> > 
> > > +++ b/drivers/scsi/ps3rom.c
> > 
> > > +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > 
> > linux/highmem.h is not included to get the kmap_* prototypes.
> 
> Beside, I don't see the point of using kmap on ppc64...

So what should I use instead?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

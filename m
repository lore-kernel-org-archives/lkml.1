Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZF3XqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZF3XqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbZF3XqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:46:05 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:49457 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756171AbZF3XqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:46:04 -0400
Date: Wed, 1 Jul 2009 01:37:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Leo (Hao) Chen" <leochen@broadcom.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090630233737.GS23292@game.jcrosoft.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C7@SJEXCHCCR02.corp.ad.broadcom.com>
 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
 <20090630184101.GI23292@game.jcrosoft.org>
 <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11797179224107559781
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:20 Wed 01 Jul     , Alan Cox wrote:
> On Tue, 30 Jun 2009 20:41:01 +0200
> Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> 
> > On 16:30 Fri 26 Jun     , Leo (Hao) Chen wrote:
> > > Hi,
> > > 
> > > The last patch. This big patch includes the minimal set of our CSP (chip support package), which is our OS independent chip supporting code and headers.  All the codes are under arch/arm/mach-bcmring directory.
> > This patch is unreadable
> > you need
> > 1) Respect the Linux coding Style
> 
> For an OS independant set of chip support defines that usually makes no
> sense
here it's really unreadable
IMHO as you will have to rewrite it to use the kernel API so it make sense
> 
> > 2) to split in small changeset
> 
> For a new submission that generally doesn't make much sense either - not
> for all the new files stuff.
here you have mixed timer, dma, irq, clock, and other new files in the same
patch, it's really hard to follow the patch. Split it a few will be easier
to review IMHO

Best Regards,
J.

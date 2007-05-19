Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbXESQUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbXESQUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXESQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:20:33 -0400
Received: from neon.samage.net ([85.17.153.66]:49508 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbXESQUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:20:32 -0400
X-Greylist: delayed 1573 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 12:20:32 EDT
Message-ID: <1441.81.207.0.53.1179591630.squirrel@secure.samage.net>
In-Reply-To: <20070519053532.GA32522@havoc.gtf.org>
References: <20070519053532.GA32522@havoc.gtf.org>
Date: Sat, 19 May 2007 18:20:30 +0200 (CEST)
Subject: Re: [PATCH] sata_sil: Greatly improve DMA support
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 938925967a2432a0d8c7279c30be63be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 07:35, Jeff Garzik wrote:
>
> Since Alan expressed a desire to see Large Block Transfer (LBT) support
> in pata_sil680, I though I would re-post my patch for adding LBT support
> to sata_sil.
>
> Silicon Image's Large Block Transfer (LBT) support is a vendor-specific
> DMA scatter/gather engine, which enables 64-bit DMA addresses (where
> supported by platform) and eliminates the annoying 64k DMA boundary
> found in legacy PCI IDE BMDMA engines.
>
> This hardware is open hardware.  Docs for both PATA and SATA can be
> found at http://gkernel.sourceforge.net/specs/sii/
>
> LBT support works the same way in both pata_sil680 and sata_sil, so
> maybe a motivated individual could take use this patch as an inspiration
> for doing the same thing with pata_sil680.
>
> NOTE:  This patch works for me on x86 and x86-64.  However, other
> testers reported problems, which is why it is not upstream.

This patch seems to work with my SiI 3512, though I don't notice any
difference, neither a speedup, nor a slowdown. Hdparm gives the same
speeds (-tT), and cp -a'ing kernel sources is abysmal slow in both cases,
(need to look into that one) so I didn't really test it that well.

Greetings,

Indan



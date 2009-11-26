Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbZKZOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbZKZOz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZKZOzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:55:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59315 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZKZOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Q3SdnbCUxKsga5hdPsGIE1C0Jqvsi1u4UYipDj4g+eKvl4Zr4c1Y+eImgOOuq0SPey
         w7b+cCFMupORWg2TEkouGYze8ySGIOBnhmZN8l6yAs8Tpjpol8WtpJPAxFe/1tMBu1CF
         oR9HrUJ7BJaGkDy38fl5fB+utIMonuAUyerh8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 15:53:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170415.5446.15073.sendpatchset@localhost> <20091125172552.6817e3da@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125172552.6817e3da@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911261553.58941.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:25:52 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:04:15 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_efar: MWDMA0 is unsupported
> > 
> > MWDMA0 timings cannot be met with the PIIX based controller
> > programming interface.
> 
> The efar documentation makes no reference to not being capable of MWDMA0,
> so where does this come from ? No MWDMA0 is an Intel erratum it appears.

No MWDMA0 support is a common issue on all 'PIIX-like' controllers.

In case of this chipset while the (preliminary) documentation claims MWDMA0
support on the 'FEATURES' page the later 'programming guide' part describes
only PIO0-4, SWDMA2, MWDMA1-2 and UDMA0-4 transfer modes as supported.

--
Bartlomiej Zolnierkiewicz

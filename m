Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZLCVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZLCVnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZLCVnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:43:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45590 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZLCVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:43:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=AXKriSqjdsWFT94QLEPIZPZE0aH1KCwDEY1iTTBJAqM1n/mzZtzzb5YGDr3JdvXYnR
         KYI2uXU1QQ0yYY6O2jh0+i5qNL9OYnATSu8zptwRz7xyS/ZJzWWrhQeAaBYi9HFba10o
         szcWg8s28E3I4ugutE3Tizc9Iyp/8ITUfCybE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 22:42:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032045.48728.bzolnier@gmail.com> <4B182A9F.5090708@garzik.org>
In-Reply-To: <4B182A9F.5090708@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032242.05785.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 10:16:15 pm Jeff Garzik wrote:

> >        pata_efar: MWDMA0 is unsupported
> 
> skipped, pending discussion (just sent email)

The discussion was there, you were not especially interested
(http://lkml.org/lkml/2009/11/26/343).

> >        pata_hpt3x2n: fix overclocked MWDMA0 timing
> 
> skipped, pending discussion (just sent email)

ditto (http://lkml.org/lkml/2009/11/27/257).

There were no complains so I'm pretty sure Sergei was fine with it.

> >        pata_hpt3x3: Power Management fix
> 
> applied, on a hope and a prayer (did not see this posted to mailing 
> list?).  It looks correct to me.

I prefer sticking to technical facts. ;)

Patch was posted to both mailing lists: http://lkml.org/lkml/2009/11/25/321

> >        pata_via: clear UDMA transfer mode bit for PIO and MWDMA
> 
> applied -- even though Alan's comment was correct.  It is standard 
> kernel practice to place cosmetic changes into their own patches, 
> because it is standard kernel practice to break up logically distinct 
> changes.

We are talking about:

 pata_via.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

patch here (http://lkml.org/lkml/2009/11/25/380) and cosmetic change
is clearly documented in the patch description.


Do people really wonder why I find upstream to be too much hassle to
deal with?

--
Bartlomiej Zolnierkiewicz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbZKSVo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbZKSVo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZKSVo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:44:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35909 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZKSVo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:44:28 -0500
X-Greylist: delayed 7923 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2009 16:44:27 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=p+ZDmGX+fyHS2OPNyosTpEfvTaWquBMt7DzqyZgaC5vz87ApA7yXWPr9IgWTFwVUym
         G/mm7E0+r/eqiQDw5aHWMC975yjAZkTlKoArMMB8sUlH4f4ClMvq5n4QlX6N5SrQFJam
         Td2xB2ECpcH2bsfX15PRpqaO0ymOJZPGJIvOQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 22:42:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911181919.19127.bzolnier@gmail.com> <4B05BA72.2030406@garzik.org>
In-Reply-To: <4B05BA72.2030406@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911192242.59476.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 22:36:50 Jeff Garzik wrote:
> On 11/18/2009 01:19 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 17 November 2009 15:51:39 Alan Cox wrote:
> >> Signed-off-by: Alan Cox<alan@linux.intel.com>
> >> ---
> >>
> >>   drivers/ata/Kconfig |    8 ++++----
> >>   1 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >>
> >> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> >> index f2df6e2..36931e0 100644
> >> --- a/drivers/ata/Kconfig
> >> +++ b/drivers/ata/Kconfig
> >> @@ -374,7 +374,7 @@ config PATA_HPT366
> >>   	  If unsure, say N.
> >>
> >>   config PATA_HPT37X
> >> -	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
> >> +	tristate "HPT 370/370A/371/372/374/302 PATA support"
> >>   	depends on PCI&&  EXPERIMENTAL
> >>   	help
> >>   	  This option enables support for the majority of the later HPT
> >> @@ -383,7 +383,7 @@ config PATA_HPT37X
> >>   	  If unsure, say N.
> >>
> >>   config PATA_HPT3X2N
> >> -	tristate "HPT 372N/302N PATA support (Experimental)"
> >> +	tristate "HPT 372N/302N PATA support"
> >>   	depends on PCI&&  EXPERIMENTAL
> >>   	help
> >>   	  This option enables support for the N variant HPT PATA
> >
> > Maybe they are 'stable' but when it comes to features they are behind hpt366
> > (i.e. they lack PCI PM), which is also much cleaner than your drivers, easier
> > to understand and much smaller..
> 
> That sounds like an ACK to Alan's patch, to me ;-)
> 
> A libata driver can be stable, yet not have all the features of drivers/ide.
> 
> That said, I do agree that libata drivers need to have the features 
> found in the drivers/ide/ drivers.

Feel free to add them Mr. Maintainer. :)

-- 
Bartlomiej Zolnierkiewicz

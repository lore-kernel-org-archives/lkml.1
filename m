Return-Path: <linux-kernel-owner+w=401wt.eu-S934895AbZKYR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895AbZKYR7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934859AbZKYR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:59:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37953 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934849AbZKYR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BaSGyocG0vDVjkwVRl0Q6DNWhjTNQMiePnoia9m8sgNT+MByJvNCfxy3MWY7z+LAPa
         AHLQIESUlMol5DesZVCrjMDaJIvAVlc5pQAeYf3hsfCur4jG7RntbYUtkqX77e6jHyg8
         q2xFbdVfSH+7IYTsdCnrEVZ4Yj5sLndyZFBSM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
Date: Wed, 25 Nov 2009 18:52:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125174632.174666be@lxorguk.ukuu.org.uk> <4B0D6E62.3010609@garzik.org>
In-Reply-To: <4B0D6E62.3010609@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251852.40281.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:50:26 pm Jeff Garzik wrote:
> On 11/25/2009 12:46 PM, Alan Cox wrote:
> > On Wed, 25 Nov 2009 18:09:48 +0100
> > Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
> >
> >> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >> Subject: [PATCH] pata_pdc202xx_old: document known issues
> >>
> >> Document known issues with the driver to aid distribution makers,
> >> users and developers in making informed decisions instead of wasting
> >> their time needlessly.
> >>
> >> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >> ---
> >>   drivers/ata/Kconfig |    4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> Index: b/drivers/ata/Kconfig
> >> ===================================================================
> >> --- a/drivers/ata/Kconfig
> >> +++ b/drivers/ata/Kconfig
> >> @@ -583,6 +583,10 @@ config PATA_PDC_OLD
> >>   	  This option enables support for the Promise 20246, 20262, 20263,
> >>   	  20265 and 20267 adapters.
> >>
> >> +	  Known issues:
> >> +	  - UDMA transfers fail mysteriously on some chipsets
> >> +	  - ATAPI DMA is unsupported currently
> >
> > Not sure this is useful, because the reports of UDMA failures are lower
> > than most other reports. Should IPV6 have "known issues, mysterious timer
> > list corruption" for example which occurs far more. Not do we list 'no
> > atapi dma' in the help for the IDE SII driver ?
> 
> If the chip can support ATAPI DMI, but the driver does not, that 
> deserves a comment, even if it's "hardware bugs prevent ATAPI DMA" or 
> "ATAPI DMA would require much more code to support, so we did not bother 
> for now"
> 
> Ditto for things like useful ideas ("consider PIO-over-DMA in SiI 311x") 
> and other would-be-nice-to-have ideas.  These can serve as projects for 
> newbies, or reminders for old-timers.

The problem is that the old driver supported ATAPI DMA so people may have
quite different expectations than in case of never-ever-implemented-ideas.

--
Bartlomiej Zolnierkiewicz

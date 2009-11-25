Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZKYSap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZKYSap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbZKYSan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:30:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:41759 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345AbZKYSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=B8ZfAZLGXjuscMQ0jiMHDfem9wue4b6o9ic2tA9lwTFfnciCMpb2WCfRVh53qC0qCY
         goxCUHpwpMxX9JSi0mqBjvE+OvQwCwhhc6Ii96WsWWaI9+jjB7SsZuLoTPvuw5rMQ9ON
         PiJ4q991yAOFTs2tNwLegZefx9DovJMm30olo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
Date: Wed, 25 Nov 2009 19:29:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251852.40281.bzolnier@gmail.com> <4B0D71A4.6090001@garzik.org>
In-Reply-To: <4B0D71A4.6090001@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251929.45897.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 07:04:20 pm Jeff Garzik wrote:
> On 11/25/2009 12:52 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 25 November 2009 06:50:26 pm Jeff Garzik wrote:
> >> On 11/25/2009 12:46 PM, Alan Cox wrote:
> >>> On Wed, 25 Nov 2009 18:09:48 +0100
> >>> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>   wrote:
> >>>
> >>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >>>> Subject: [PATCH] pata_pdc202xx_old: document known issues
> >>>>
> >>>> Document known issues with the driver to aid distribution makers,
> >>>> users and developers in making informed decisions instead of wasting
> >>>> their time needlessly.
> >>>>
> >>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >>>> ---
> >>>>    drivers/ata/Kconfig |    4 ++++
> >>>>    1 file changed, 4 insertions(+)
> >>>>
> >>>> Index: b/drivers/ata/Kconfig
> >>>> ===================================================================
> >>>> --- a/drivers/ata/Kconfig
> >>>> +++ b/drivers/ata/Kconfig
> >>>> @@ -583,6 +583,10 @@ config PATA_PDC_OLD
> >>>>    	  This option enables support for the Promise 20246, 20262, 20263,
> >>>>    	  20265 and 20267 adapters.
> >>>>
> >>>> +	  Known issues:
> >>>> +	  - UDMA transfers fail mysteriously on some chipsets
> >>>> +	  - ATAPI DMA is unsupported currently
> >>>
> >>> Not sure this is useful, because the reports of UDMA failures are lower
> >>> than most other reports. Should IPV6 have "known issues, mysterious timer
> >>> list corruption" for example which occurs far more. Not do we list 'no
> >>> atapi dma' in the help for the IDE SII driver ?
> >>
> >> If the chip can support ATAPI DMI, but the driver does not, that
> >> deserves a comment, even if it's "hardware bugs prevent ATAPI DMA" or
> >> "ATAPI DMA would require much more code to support, so we did not bother
> >> for now"
> >>
> >> Ditto for things like useful ideas ("consider PIO-over-DMA in SiI 311x")
> >> and other would-be-nice-to-have ideas.  These can serve as projects for
> >> newbies, or reminders for old-timers.
> >
> > The problem is that the old driver supported ATAPI DMA so people may have
> > quite different expectations than in case of never-ever-implemented-ideas.
> 
> This is not rocket science :)  Have one section "known issues" and 
> another section "fun ideas to explore."  This is English code comments, 
> you may set any level of expectations.

I think it is the best to leave up to the driver maintainer
(once we find out who this person is, MAINTAINERS file still
lacks info about PATA drivers in -rc8).

--
Bartlomiej Zolnierkiewicz

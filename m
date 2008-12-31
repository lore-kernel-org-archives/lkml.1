Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYLaLla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYLaLla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYLaLlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:41:08 -0500
Received: from homer.mvista.com ([63.81.120.155]:40492 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbYLaLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:41:07 -0500
Message-ID: <495B5A4B.5030205@ru.mvista.com>
Date: Wed, 31 Dec 2008 14:40:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Question with AHCI and (UDMA/100 vs. UDMA/133)
References: <alpine.DEB.1.10.0812300651190.11356@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812300651190.11356@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Justin Piszcz wrote:

> Do some chipsets (SiI 3132 vs. Intel ICH9) run certain drives at 
> UDMA/100 vs. UDMA/133?

   Intel ICH chipsets never supported UDMA/133.

> I have several 750GB WD drives (exact make/model) and the ones on the 
> intel chipset show up as:
>
> [    1.407321] ata3.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max 
> UDMA/133
> [    1.407409] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 
> 31/32)
> [    1.408300] ata3.00: configured for UDMA/133

   I'm *very* surprised to see that on ICH9. Oh wait, that's SATA 
controller, not PATA! Then I don't know...

> The ones on the SiI 3132 chipset show up as:
>
> [    9.604413] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    9.619024] ata11.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max 
> UDMA/133
> [    9.619111] ata11.00: 1465149168 sectors, multi 16: LBA48 NCQ 
> (depth 31/32)
> [    9.620029] ata11.00: configured for UDMA/100
>
> If they are both 3.0 Gbps, are they both the same speed even though 
> one is configured for a slower speed than the other?

   I'd think so.

> Or is it the case that the SiI 3132 does not support AHCI and that is 
> the reason for the difference?  Does it make any difference in 
> performance?

   Hardly -- if these are true SATA controllers.

MBR, Sergei



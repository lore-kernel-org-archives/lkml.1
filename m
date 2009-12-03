Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbZLCUuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbZLCUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZLCUuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:50:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62744 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZLCUuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cOobMyjoxo88pjKUwXh0LzmQk0niP99QbGrNqGabSrIUocrUPx+i1gm2yi1wM8OP0D
         ZWp31gKxUm9GOI2CAGAQoSxvO0AHdM4ZiZgAk9oXPbPGzhHedZFKHNTgcKs4Gp8U7xhf
         COHG0APgfAxLE/Fw0UMCqpMMsR0aXAYf7DGYs=
Message-ID: <4B182486.6050505@garzik.org>
Date: Thu, 03 Dec 2009 15:50:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
References: <20091125170218.5446.13513.sendpatchset@localhost>	<20091125170415.5446.15073.sendpatchset@localhost>	<20091125172552.6817e3da@lxorguk.ukuu.org.uk>	<200911261553.58941.bzolnier@gmail.com> <20091126151546.6c891014@lxorguk.ukuu.org.uk>
In-Reply-To: <20091126151546.6c891014@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2009 10:15 AM, Alan Cox wrote:
> On Thu, 26 Nov 2009 15:53:58 +0100
> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
>
>> On Wednesday 25 November 2009 06:25:52 pm Alan Cox wrote:
>>> On Wed, 25 Nov 2009 18:04:15 +0100
>>> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
>>>
>>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> Subject: [PATCH] pata_efar: MWDMA0 is unsupported
>>>>
>>>> MWDMA0 timings cannot be met with the PIIX based controller
>>>> programming interface.
>>>
>>> The efar documentation makes no reference to not being capable of MWDMA0,
>>> so where does this come from ? No MWDMA0 is an Intel erratum it appears.
>>
>> No MWDMA0 support is a common issue on all 'PIIX-like' controllers.
>>
>> In case of this chipset while the (preliminary) documentation claims MWDMA0
>> support on the 'FEATURES' page the later 'programming guide' part describes
>> only PIO0-4, SWDMA2, MWDMA1-2 and UDMA0-4 transfer modes as supported.
>
> Cool - I only have the original docs.

ACK Bart's patch, then?

This thread was a bit unclear, and I want to be certain (well, as 
certain as we can be :))

	Jeff




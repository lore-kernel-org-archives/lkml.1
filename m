Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZLCVEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZLCVEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZLCVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:04:39 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51951 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLCVEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=amsHrE9JoohvW+6UaI6OB3cDRJ9F65GdXlSAcYl5RwQrThs5FNOtc9bIZjFjTyrQ6V
         IQb/WTWdYMEVkFzH1Ofx9jm3iyTIO0v+7bUvndgmDcgRHhSwygPqb1dBov1w+EQonRRa
         2mLeTAwdB8c6OmLg/pdITeL+MJl/fA1wgmnSM=
Message-ID: <4B1827EA.4050608@garzik.org>
Date: Thu, 03 Dec 2009 16:04:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
References: <200911261728.36433.bzolnier@gmail.com> <200911261800.55025.bzolnier@gmail.com> <4B0EB986.2010801@ru.mvista.com>
In-Reply-To: <4B0EB986.2010801@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2009 12:23 PM, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
>
>>> MWDMA0 timings cannot be met with the PIIX based controller
>>> programming interface.
>
>>> This change should be safe as this is how we have been doing
>>> things in IDE it8213 host driver for years.
>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>> Verified with the documentation (similar case as with pata_efar).
>
>> Uhhh, no...
>
>> Too many damn drivers.
>
>> Too much damn duplication.
>
>> Too much damn subtle differences here and there.
>
>> The hardware is probably fine for MWMDA0 when it comes to
>> pata_{efar,it8213},
>> it just not documented properly in the data sheet.
>
> How so with pata_efar? The active/recovery bitfields are still 2-bit
> wide, no?

So....  pata_it8213 is fine for MWDMA0, then?

	Jeff





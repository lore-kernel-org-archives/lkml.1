Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab0BCRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:25:28 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52401 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab0BCRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bcPAmMfLbK0yCC2kCbhN/0d8MQecL9thyHIsSytNyKCnvcSwYfF1ASsA0D2LFYRQK6
         vSLY6pICww/q0HZBVJddG92xemaUkL/61GX6fraE1xQucyd9rr28t+XzKji456l4WX5f
         1Vrpkmp3IYbBVMCd0wVU0SbsOPxXCYiagIhlQ=
Message-ID: <4B69B182.9040400@pobox.com>
Date: Wed, 03 Feb 2010 12:25:22 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com> <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com> <4B69B0A0.2040701@teksavvy.com>
In-Reply-To: <4B69B0A0.2040701@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 12:21 PM, Mark Lord wrote:
> Joe Perches wrote:
>> String constants that are continued on subsequent lines with \
>> are not good.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>> drivers/ata/pata_at91.c | 4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
>> index 41c94b1..d222c0d 100644
>> --- a/drivers/ata/pata_at91.c
>> +++ b/drivers/ata/pata_at91.c
>> @@ -153,8 +153,8 @@ static void pata_at91_set_piomode(struct ata_port
>> *ap, struct ata_device *adev)
>> /* Compute ATA timing and set it to SMC */
>> ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
>> if (ret) {
>> - dev_warn(ap->dev, "Failed to compute ATA timing %d, \
>> - set PIO_0 timing\n", ret);
>> + dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0
>> timing\n",
>> + ret);
> ..
>
> NAK. Just stick the ret); part onto the same line and be done with it.

Agreed...



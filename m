Return-Path: <linux-kernel-owner+w=401wt.eu-S935802AbZFOWQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935802AbZFOWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZFOWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:16:49 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:32875 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZFOWQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <200906152335.48926.mroth@nessie.de>
References: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
	 <200906152335.48926.mroth@nessie.de>
Date: Mon, 15 Jun 2009 15:16:49 -0700
X-Google-Sender-Auth: d03a34d099f97fa6
Message-ID: <c8284b5b0906151516x6774545u6308e45049bb094c@mail.gmail.com>
Subject: Re: [PATCH 5/6] Unified AVR32/AT91 MCI Driver Support for a VCC Pin
From: Rob Emanuele <poorarm@shoreis.com>
To: Michael Roth <mroth@nessie.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That would be fine with me.

On Mon, Jun 15, 2009 at 2:35 PM, Michael Roth<mroth@nessie.de> wrote:
>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index 1c1a4b3..a639b93 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -214,6 +214,8 @@ struct atmel_mci_slot {
>>
>>       int                     detect_pin;
>>       int                     wp_pin;
>> +     int                     vcc_pin;
>> +     bool                    vcc_pin_act_low;
>
> Maybe, just 'vcc_active_low' is more clear?
>
> Most other kernel code use 'active_low' or 'xyz_active_low' as far as I can
> see.
>
>

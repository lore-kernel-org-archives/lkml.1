Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZKIN3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZKIN3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZKIN3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:29:42 -0500
Received: from smtp.nokia.com ([192.100.105.134]:50101 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbZKIN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:29:41 -0500
Message-ID: <4AF8193A.70505@nokia.com>
Date: Mon, 09 Nov 2009 15:29:30 +0200
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH v2 2/2] omap: RX-51: enable tsc2005
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>	<1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com> <87d43ufih0.fsf@purkki.valot.fi>
In-Reply-To: <87d43ufih0.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2009 13:29:35.0671 (UTC) FILETIME=[ADE46C70:01CA6140]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Kalle Valo wrote:
> Aaro Koskinen <aaro.koskinen@nokia.com> writes:
> 
>> Enable tsc2005 touchscreen driver on the RX-51 board.
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
>> ---
>>
>> The patch is for 2.6.32-rc6.
> 
> [...]
> 
>> +static struct spi_board_info rx51_peripherals_spi_board_info[] = {
>> +	[0] = {
>> +		.modalias		= "tsc2005",
>> +		.bus_num		= 1,
>> +		.chip_select		= 0,
>> +		.irq			= OMAP_GPIO_IRQ(RX51_TSC2005_IRQ_GPIO),
>> +		.max_speed_hz		= 6000000,
>> +		.controller_data	= &tsc2005_mcspi_config,
>> +		.platform_data		= &tsc2005_config,
>> +	},
>> +};
> 
> I sent a wl1251 patch which adds spi_board_info and conflicts with
> this patch:
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17604.html
> 
> How do we handle this?

I can resend/rebase this patch once the wl1251 patch is integrated.

BTW, check the comment from Tommi Rantala - spi_board_info can be marked
with __initdata.

A.

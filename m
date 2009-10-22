Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZJVLGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZJVLGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZJVLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:06:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61022 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJVLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:06:31 -0400
Date: Thu, 22 Oct 2009 14:05:32 +0300 (EEST)
From: Ilkka Koskinen <ikoskine@nokia.com>
X-X-Sender: ikoskine@tumpelo.ntc.nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [Resend PATCH 2/2] twl4030: Enable low-power mode to 32kHz
 oscillator
In-Reply-To: <20091021221718.GB17796@sortiz.org>
Message-ID: <alpine.DEB.2.00.0910221346030.3792@tumpelo.ntc.nokia.com>
References: <1256044973-14548-1-git-send-email-ilkka.koskinen@nokia.com> <1256044973-14548-2-git-send-email-ilkka.koskinen@nokia.com> <20091021221718.GB17796@sortiz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 22 Oct 2009 11:06:21.0150 (UTC) FILETIME=[AFB917E0:01CA5307]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Samuel,

On Thu, 22 Oct 2009, ext Samuel Ortiz wrote:
> On Tue, Oct 20, 2009 at 04:22:53PM +0300, Ilkka Koskinen wrote:
>> +struct twl4030_clock_init_data {
>> +     int ck32k_lowpwr_enable;
> I guess you could use a bool here ?

Good point. I'll change it.

Cheers, Ilkka

>> +};
>> +
>>  struct twl4030_bci_platform_data {
>>       int *battery_tmp_tbl;
>>       unsigned int tblsize;
>> @@ -403,6 +407,7 @@ extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
>>
>>  struct twl4030_platform_data {
>>       unsigned                                irq_base, irq_end;
>> +     struct twl4030_clock_init_data          *clock;
>>       struct twl4030_bci_platform_data        *bci;
>>       struct twl4030_gpio_platform_data       *gpio;
>>       struct twl4030_madc_platform_data       *madc;
>> --
>> 1.6.0.4
>>
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

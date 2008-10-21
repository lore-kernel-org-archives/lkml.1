Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYJUTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYJUTk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYJUTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:40:17 -0400
Received: from pih-relay05.plus.net ([212.159.14.18]:32798 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYJUTkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:40:16 -0400
Message-ID: <48FE3017.4080009@mimc.co.uk>
Date: Tue, 21 Oct 2008 20:40:07 +0100
From: Mark Jackson <mpfj@mimc.co.uk>
Organization: Mercury IMC Ltd
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: i2c@lm-sensors.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [i2c] [PATCH v2] Add support for Dallas DS28CM00 Unique ID chip
References: <48FDED5E.5080605@mimc.co.uk>	<20081021173505.2f7673e2@hyperion.delvare>	<48FE22A2.7030604@mimc.co.uk> <20081021211219.18fb7d84@hyperion.delvare> <48FE2ADC.8020203@mimc.co.uk>
In-Reply-To: <48FE2ADC.8020203@mimc.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 993c0a4f56792ca9b857794051d2d371
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Jackson wrote:
> Jean Delvare wrote:
>> Hi Mark,
>>
>> On Tue, 21 Oct 2008 19:42:42 +0100, Mark Jackson wrote:
>>> Jean Delvare wrote:
>>>> Nack. No new drivers under drivers/i2c/chips please, it's going away
>>>> soon.
>>> Okay ... where should any new drivers be located ?
>>
>> Depends of what the device does.
>> * Hardware monitoring chip drivers go to drivers/hwmon
>> * RTC chip drivers go to drivers/rtc
>> * I/O expander drivers go to drivers/gpio
>> If you can't find a suitable directory under drivers, either create a
>> new one if that makes sense, or put your driver under drivers/misc.
> 
> Ah, now I understand !!  I think drivers/misc is probably a good a place 
> as any,

In fact, I now realise that the device is *really* just a read-only eeprom.

So I'm guessing I don't need a custom driver, I can just use the existing
"at24" driver.

Ho hum ...

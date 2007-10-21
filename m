Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXJULN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXJULN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXJULNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:13:06 -0400
Received: from m-04.th.seeweb.it ([217.64.195.227]:40686 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXJULNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:13:04 -0400
Message-ID: <471B32D8.6040508@users.sourceforge.net>
Date: Sun, 21 Oct 2007 13:07:04 +0200
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22]
 i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net> <20071018195202.GA6962@ucw.cz>
In-Reply-To: <20071018195202.GA6962@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek ha scritto:
> Hi!
>> egolas558@users.sourceforge.net ha scritto:
>>     
>>> Kernel: 2.6.22-r5
>>> Kernel option: i8042.nomux=1
>>>       
>> I am now using kernel 2.6.22-r8 (Gentoo) and the following kernel options:
>>
>> i8042.nomux=1 acpi=off
>>
>> I have tried kernel 2.6.23-rc9 but the problem is still there.
>>     
> Try usb keyboard.
>   
The USB keyboard is not affected by the problem, and more importantly it
has not the latencies in ACPI mode which the embedded PS2 keyboard has.

> Try disabling lm_sensors.
>   
lm_sensors was not installed at all. I have now enabled HWMON and other
CONFIG_I2C_* kernel config parameters to use lm_sensors (without success).

> Is it smp box?
>   
It is not but from the sensors-detect's log seems like the motherboard
supports it.

Best regards,
--
  Daniele



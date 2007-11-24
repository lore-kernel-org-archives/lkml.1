Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXKXTLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXKXTLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXKXTK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:10:59 -0500
Received: from m-04.th.seeweb.it ([217.64.195.227]:55979 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXKXTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:10:58 -0500
Message-ID: <474877F9.3050901@users.sourceforge.net>
Date: Sat, 24 Nov 2007 20:14:01 +0100
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Len Brown <lenb@kernel.org>
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22]
 i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
References: <47001841.1000107@users.sourceforge.net> <20071020183309.GB11373@elf.ucw.cz> <471B1F44.5050801@users.sourceforge.net> <200711232327.33622.lenb@kernel.org>
In-Reply-To: <200711232327.33622.lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown ha scritto:
> On Sunday 21 October 2007 05:43, legolas558@users.sourceforge.net wrote:
>>  have emerged lm_sensors but can't get it running - it keeps saying "No
>> sensors found!" and complaining about kernel drivers not properly setup.
>> I have attached the output of sensors-detect, from which it seems that
>> the kernel is OK.
>>     
> In this case, getting sensors installed is the opposite of what you want to do.
> The idea is to simplify the system until it works, then figure out what
> simplification made it work.
>
> ie. disable sensors entirely by building a kernel with CONFIG_HWMON=n
>
> If that makes things work, then it is a clue.
> If that was disabled already, then just keep it disabled.
>   
It is disabled since when I abandoned the lm_sensors approach; I 
remember that I did some more testing with lm_sensors and got almost all 
chips identified, although didn't know how to use lm_sensors to generate 
some useful logs.
I agree with you that we have to simplify the system down.
Note: when I built kernel 2.6.24-rc3 to see if it is still affected by 
bug #9147, CONFIG_HWMON was enabled instead (and the problem was 
verified anyway). I don't recall how that setting got enabled, however I 
did not enable it manually and I was not enabling lm_sensors support.

Best regards,
--
  Daniele C.

> cheers,
> -Len
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   


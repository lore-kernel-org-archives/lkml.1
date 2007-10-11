Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbXJKMwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbXJKMwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXJKMwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:52:16 -0400
Received: from static-71-246-207-116.washdc.fios.verizon.net ([71.246.207.116]:43082
	"EHLO mail.gnupooh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXJKMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:52:15 -0400
Message-ID: <470E1C42.1040600@gnupooh.org>
Date: Thu, 11 Oct 2007 08:51:14 -0400
From: Rick Niles <fniles@gnupooh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Help with rtc to hpet conversion of OSGPS driver
References: <470E109C.6020903@gnupooh.org> <Pine.LNX.4.64.0710111437040.32234@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710111437040.32234@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe I'm way off here, but that seems to be the function to register a 
RTC hardware chip with the kernel.  I want to use a real-time clock 
interrupt to wake up my driver and service the GPS correlator, about 
every 500ms.  Please let me know if I'm misunderstanding.

Jan Engelhardt wrote:
> On Oct 11 2007 08:01, Rick Niles wrote:
>   
>> I've been trying to make the driver work with
>> Fedora 7 and the 2.6.22 kernel, but the rtc_register() and other RTC functions
>> seems to have been removed.
>>     
>
> grep -r rtc_device_register drivers/rtc/
>
> Does that help?
>
>   
>> I see they've been replaced by the corresponding
>> HPET functions, which is great. However, hpet_register() always returns -16
>> (EBUSY).  This could be because I lack the correct hardware (I'm running 32-bit
>> Linux on a Athlon64 with an NVIDIA chipset) or some other reason.
>>     


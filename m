Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZIXHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZIXHRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZIXHRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:17:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:49543 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZIXHRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qRMGPJOQ902dzOVp2KitgrhT3Q5V+mK9p/KGCZIZJlN4Slftu3KVSgTKLUuHEtGIDy
         feEjOfZj/oe8IRaNDqgedkzjgZGolME+iV/0iSbp/Y6aqO1ESwtd+dCTGHeyrNdMIIF9
         7DikuDyJVQBxkhbInv8nREzhvcevexGTw/SLI=
MIME-Version: 1.0
In-Reply-To: <20090922180356.GJ14890@atomide.com>
References: <51076.192.168.10.88.1253639068.squirrel@dbdmail.itg.ti.com>
	 <20090922180356.GJ14890@atomide.com>
Date: Thu, 24 Sep 2009 12:47:16 +0530
Message-ID: <d6a0f7aa0909240017o3b201848j87bafeebebd048c2@mail.gmail.com>
Subject: Re: [PATCH 1/3] OMAP UART: Adding support for omap-serial driver.
From: Govindraj <govindraj.ti@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:33 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Govindraj.R <govindraj.raja@ti.com> [090922 10:06]:
>> From: Govindraj R <govindraj.raja@ti.com>
>>
>> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
>
> Why do you have the same subject anad description is the same for all of them?
>
>> --- a/drivers/serial/Kconfig
>> +++ b/drivers/serial/Kconfig
>> @@ -1359,6 +1359,98 @@ config SERIAL_OF_PLATFORM
>>         Currently, only 8250 compatible ports are supported, but
>>         others can easily be added.
>>
>> +config SERIAL_OMAP
>> +     bool "OMAP serial port support"
>> +     depends on ARM && ARCH_OMAP
>> +     select SERIAL_CORE
>> +     help
>> +     If you have a machine based on an Texas Instruments OMAP CPU you
>> +     can enable its onboard serial ports by enabling this option.
>> +
>> +config SERIAL_OMAP_CONSOLE
>> +     bool "Console on OMAP serial port"
>> +     depends on SERIAL_OMAP
>> +     select SERIAL_CORE_CONSOLE
>> +     help
>> +     If you have enabled the serial port on the Texas Instruments OMAP
>> +     CPU you can make it the console by answering Y to this option.
>> +
>> +     Even if you say Y here, the currently visible virtual console
>> +     (/dev/tty0) will still be used as the system console by default, but
>> +     you can alter that using a kernel command line option such as
>> +     "console=ttyS0". (Try "man bootparam" or see the documentation of
>> +     your boot loader (lilo or loadlin) about how to pass options to the
>> +     kernel at boot time.)
>> +
>> +config SERIAL_OMAP_DMA_UART1
>> +     bool "UART1 DMA support"
>> +     depends on SERIAL_OMAP
>> +     help
>> +     If you have enabled the serial port on the Texas Instruments OMAP
>> +     CPU you can enable the DMA transfer on UART 1 by answering
>> +      to this option.
>> +
>
> Didn't I already comment these options should be passed in platform_data
> from board-*.c files?
>

Will resend PATCH v1 incorporating SERIAL_OMAP_UARTx_RXDMA_BUFSIZE
and SERIAL_OMAP_UARTx_RXDMA_BUFSIZE values into platform data and will
clean up in Kconfig.

Thanks for your review comments.

---
Regards,
Govindraj.R

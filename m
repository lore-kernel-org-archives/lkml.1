Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYKMOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYKMOnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYKMOno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:43:44 -0500
Received: from mail.atmel.fr ([81.80.104.162]:41038 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYKMOno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:43:44 -0500
Message-ID: <491C3D16.1050501@atmel.com>
Date: Thu, 13 Nov 2008 15:43:34 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus@drzeus.cx>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
References: <491C0C05.6040301@atmel.com> <20081113134818.GA9161@fluff.org.uk>
In-Reply-To: <20081113134818.GA9161@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks :
> On Thu, Nov 13, 2008 at 12:14:13PM +0100, Nicolas Ferre wrote:
>> Needed to use the atmel-mci driver in a architecture
>> independent manner.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> arch/avr32/boards/atngw100/setup.c       |    2 +-
>> arch/avr32/boards/atstk1000/atstk1002.c  |    2 +-
>> arch/avr32/boards/atstk1000/atstk1003.c  |    2 +-
>> arch/avr32/boards/atstk1000/atstk1004.c  |    2 +-
>> arch/avr32/include/asm/atmel-mci.h       |   39 ------
>> arch/avr32/mach-at32ap/at32ap700x.c      |    2 +-
>> drivers/mmc/host/atmel-mci.c             |    2 +-
>> include/linux/atmel-mci.h                |   39 ++++++
> 
> Would people object to putting this in include/linux/mmc/atmel.h
> to avoid making include/linux abound with device/subsystem/machine
> specific header files?

I tend to agree *but* it seems that header files in include/linux/mmc
are mostly sd/mmc subsystem core files (I mean, not driver ones).
Although, a bunch of atmel-a_driver.h files are already in include/linux...

Pierre, a comment ?

Regards,
-- 
Nicolas Ferre


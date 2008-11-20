Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYKTO1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYKTO1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbYKTOZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:25:49 -0500
Received: from mail.atmel.fr ([81.80.104.162]:37265 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbYKTOZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:25:48 -0500
Message-ID: <4925734E.1060606@atmel.com>
Date: Thu, 20 Nov 2008 15:25:18 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Ben Dooks <ben-linux@fluff.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
References: <491C0C05.6040301@atmel.com>	<20081113134818.GA9161@fluff.org.uk>	<491C3D16.1050501@atmel.com> <20081119193631.448ae25e@mjolnir.drzeus.cx>
In-Reply-To: <20081119193631.448ae25e@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Thu, 13 Nov 2008 15:43:34 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Ben Dooks :
>>> Would people object to putting this in include/linux/mmc/atmel.h
>>> to avoid making include/linux abound with device/subsystem/machine
>>> specific header files?
>> I tend to agree *but* it seems that header files in include/linux/mmc
>> are mostly sd/mmc subsystem core files (I mean, not driver ones).
>> Although, a bunch of atmel-a_driver.h files are already in include/linux...
>>
>> Pierre, a comment ?
>>
> 
> I'd prefer if include/linux/mmc could stay clean and just have core
> stuff since the header files are basically the reference documentation
> for the subsystem. But if you can't find any other way...

I agree with both of you Pierre and Antonio.
Haavard, I submit a patch which also fix the mimc200 board very soon now.

Bye,
-- 
Nicolas Ferre


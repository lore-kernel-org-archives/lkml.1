Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYGRNay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYGRNay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGRNar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:30:47 -0400
Received: from mail.atmel.fr ([81.80.104.162]:52630 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYGRNaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:30:46 -0400
Message-ID: <48809B00.1070405@atmel.com>
Date: Fri, 18 Jul 2008 15:30:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] at91_mci: Enable MMC_CAP_SDIO_IRQ only when it actually
 works
References: <487F120F.2050305@atmel.com> <20080717125544.36f41947@mjolnir.drzeus.cx>
In-Reply-To: <20080717125544.36f41947@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Thu, 17 Jul 2008 11:34:07 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> According to the datasheets AT91SAM9261 does not support
>> SDIO interrupts, and AT91SAM9260/9263 have an erratum
>> requiring 4bit mode while using slot B for the interrupt
>> to work.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> Not all SDIO cards use 4-bit mode, so it looks to me like you have to
> disable it completely (unless there's a third revision where it works
> without any fine print?).

Well, I understand.

In your opinion, a printed warning that says to be sure to use only 
4-bit mode SDIO cards on slot B... is not acceptable ?

It kind of disappoints me to remove this feature as the 
at91sam9260ek/9xe/9g20 board uses only slot B, and I really like to 
connect SDIO with IRQ on it.

Regards,
-- 
Nicolas Ferre


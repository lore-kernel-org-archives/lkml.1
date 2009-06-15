Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZFOOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZFOOwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFOOwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:52:12 -0400
Received: from mail.atmel.fr ([81.80.104.162]:37761 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZFOOwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:52:12 -0400
Message-ID: <4A365FE6.8080908@atmel.com>
Date: Mon, 15 Jun 2009 16:51:18 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Rob Emanuele <poorarm@shoreis.com>, Andrew Victor <avictor.za@gmail.com>,
       Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports
 both 	MCI slots used at the same time
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>	<20090611095432.2e3a4067@hskinnemoen-d830>	<c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>	<4A3219F6.6000300@atmel.com> <20090612112900.4435f70f@hskinnemoen-d830>
In-Reply-To: <20090612112900.4435f70f@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> Nicolas Ferre wrote:
>>> Well, what is the best way to differentiate it from the at91_mci
>>> driver and keep users from trying to use both drivers?  
>> I propose that we setup a kind of choice sub menu in the Kconfig for
>> those two drivers when they are both supported.
> 
> Shouldn't it be enough to simply add
> 
> 	depends on !THE_OTHER_DRIVER
> 
> to both of them?

It does not seems to work...

> Btw, what are the long-term plans for this? Should the at91_mci driver
> be phased out once the atmel-mci driver supports all at91 and avr32
> devices?

In my opinion, it is a bit early to tell. My thoughts were that I
suspect we should keep at91_mci for at91rm9200 and at91sam9261/9261s as
they contain an older revision of the MCI IP. In the meantime, Rob tend
to integrate also code to manage those chips (without RDPROOF/WRPROOF
switch).

So, lets see how far we can go with the atmel-mci on at91 chips and
then, consider a phase out.

Regards,
-- 
Nicolas Ferre


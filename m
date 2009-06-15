Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbZFOSEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbZFOSEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZFOSE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:04:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbZFOSE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:04:27 -0400
MIME-Version: 1.0
In-Reply-To: <4A366FFA.80700@atmel.com>
References: <c8284b5b0906121759o4057deb6kf59f818fa759ce57@mail.gmail.com>
	 <4A366FFA.80700@atmel.com>
Date: Mon, 15 Jun 2009 11:04:28 -0700
X-Google-Sender-Auth: 0d671dc7ef547d69
Message-ID: <c8284b5b0906151104j204b8b96j7248d20fb7498f82@mail.gmail.com>
Subject: Re: [PATCH 2/6] Unified AVR32/AT91 MCI Platform Driver
From: Rob Emanuele <poorarm@shoreis.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

>> +config AT91_2MMC
>> +     bool "Use both MMC Ports"
>> +     depends on MACH_AT91SAM9G20EK
>> +     help
>> +       Select this if you have connected both MMC Slots.  Answer No if unsure.
>> +
>
> Well I do not like this configuration addition. If it is created
> to differencing your custom board with the -EK, we will have to
> consider something else.
>

Why don't I build out a patch for a new board that demonstrates using
the atmel_mci on the AT91?  I'll call it something like
board-sam9g20-ek-2slot-mod.c.  I may have mentioned that Atmel's rev D
of this board has both slot already on it but they don't know when its
going to production.  They still have to sell out of rev B and C.

In related news, I have a small number of adapter boards that I'm
using bring MCI Slot A to a micro sd slot on the AT91SAM9G20-EK.  They
also fit the AT91SAM9XE-EK and possibly others.  If you or anyone else
is working on this patch set and would like to test with both slots I
can send a few of them out.

Thanks,

Rob

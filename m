Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbZFLSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbZFLSSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761230AbZFLSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:18:11 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59566 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZFLSSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <4A3219F6.6000300@atmel.com>
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
	 <20090611095432.2e3a4067@hskinnemoen-d830>
	 <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
	 <4A3219F6.6000300@atmel.com>
Date: Fri, 12 Jun 2009 11:18:10 -0700
X-Google-Sender-Auth: 0ce73ace7202942b
Message-ID: <c8284b5b0906121118r413bff3frd4a1d9e12e76bfca@mail.gmail.com>
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports both 
	MCI slots used at the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas & Haavard,

>> Well, what is the best way to differentiate it from the at91_mci
>> driver and keep users from trying to use both drivers?
>
> I propose that we setup a kind of choice sub menu in the Kconfig for
> those two drivers when they are both supported.
>

I'll try Haavard's suggestion of making the 2 drivers mutually
exclusive and I'll remove "Unified" verbiage.

>> Who would that be as I haven't seen anyone who maintains any of those
>> boards other than the at91rm8200 (at least nothing listed in the
>> MAINTAINERS file)?  The board-sam9g20ek.c platform only shows Atmel as
>> the most recent copyright.
>
> Hey, AT91 are very well maintained, SAM9 as well as at91rm9200.
> So, AT91 specific bits should be sent to this mailing-list with Andrew
> Victor in copy.

I never meant to imply that they were not maintained or even not
maintained well, only that the maintainer's contact information was
not obvious.  Below is a patch to correct that listing for Andrew
Victor.

> I will also certainly add comments on this code.
>

I appreciate any comments you have.

--Rob

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d460c9..a3bc13b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -472,7 +472,7 @@ M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained

-ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
+ARM/ATMEL AT91RM9200 & AT91SAM9* ARM ARCHITECTURES
 P:	Andrew Victor
 M:	linux@maxim.org.za
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)

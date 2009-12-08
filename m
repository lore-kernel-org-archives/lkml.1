Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZLHQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZLHQAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 11:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbZLHQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 11:00:47 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:34818 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbZLHQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 11:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=Ly+mMORnEy/4qkahAbYkd21yfZpPRXy8qjqh391N5WC8D4QqHpylJsiPtK373FG4SZ
         yZiSA+nAfcVO9tSflEAfIxAFEgTEtypX0CZziCAJwb6AXfN7653NzpTpuQFiRoX4iViS
         jvvkgnjcCaoOpPXl7FQM0AU1+21bNF69RCUTk=
Message-ID: <4B1E782D.3000102@gmail.com>
Date: Tue, 08 Dec 2009 21:00:45 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "A. Porodko" <panda@chelcom.ru>
CC: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for MSP430 and SOC audio support for Neuros OSD2 platform
 code.
References: <4B1BC0E7.1010403@chelcom.ru>
In-Reply-To: <4B1BC0E7.1010403@chelcom.ru>
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Please, consider this patch for Neuros OSD2 platform code. Particular
drivers code have been sent to consideration of respective maintainers.

Thank you.

P.S. Change log added.

-------------------------------------------------------------------------
>From e5aef120a1a4af6b678b8ffe6d9be1d065cb305e Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Sat, 5 Dec 2009 15:54:42 +0500
Subject: [PATCH] Neuros OSD2 board platform code patch for supporting msp430
 microcontroller and sound soc.

Initial release. Neuros OSD2 board i2c platform data description for MSP430
microprocessor and Audio SOC support. MSP430 firmware perform various operations.
Such as IR remote, RTC timer and etc. Audio SOC is very similar to DM6446EVM
board, the only difference here is i2c port address.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 arch/arm/mach-davinci/board-neuros-osd2.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index bd9ca07..28b3d67 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -202,6 +202,12 @@ static struct davinci_i2c_platform_data ntosd2_i2c_pdata = {
 };
 
 static struct i2c_board_info __initdata ntosd2_i2c_info[] =  {
+	{					/* MSP430 interface	*/
+		I2C_BOARD_INFO("davinci_msp", NTOSD2_MSP430_I2C_ADDR),
+	},
+	{
+		I2C_BOARD_INFO("tlv320aic3x", NTOSD2_AUDIOSOC_I2C_ADDR),
+	},
 };
 
 static	int ntosd2_init_i2c(void)
-- 
1.5.6.5

-------------------------------------------------------------------------


-- 
Best regards
Andrey A. Porodko
 


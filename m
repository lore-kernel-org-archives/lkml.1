Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYDUNgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYDUNgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbYDUNeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:34:18 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64105 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761604AbYDUNeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:34:15 -0400
Subject: Re: [PATCH 22/37] Input: add PS/2 serio driver for AVR32 devices
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Hans-Christian Egtvedt <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
In-Reply-To: <9f9439e92a7fb057d31a19636b99e43306192756.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
	 <9f9439e92a7fb057d31a19636b99e43306192756.1208783694.git.dmitry.torokhov@gmail.com>
Content-Type: multipart/mixed; boundary="=-V86+Swls0hF2VHdwNq8T"
Date: Mon, 21 Apr 2008 15:33:58 +0200
Message-Id: <1208784838.30244.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V86+Swls0hF2VHdwNq8T
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-04-15 at 01:30 -0400, Hans-Christian Egtvedt wrote:
> Add support for the PSIF peripheral on AVR32 AP7 devices.  It is implemented
> as a serio driver and will behave like a serio 8042 device.
> 
> The driver has been tested with a Dell keyboard capable of running on 3.3
> volts and a Logitech mouse on the STK1000 + STK1002 starter kit.  The Logitech
> mouse was hacked by cutting the cord and using a bi-directional voltage
> converter to get the required 5 volt I/O level.
> 
> For more information about the PSIF module, see the datasheet for AT32AP700X at
> http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
> 
> Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---

<snipp serio driver for AVR32>

> +MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");

This address has been changed, please apply the attached patch.

> +MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
> +MODULE_LICENSE("GPL");

PS! I think my old address even bounces a message, sorry about that :(

-- 
With kind regards,
Hans-Christian Egtvedt, Applications Engineer

--=-V86+Swls0hF2VHdwNq8T
Content-Disposition: attachment; filename*0=0001-Change-MODULE_AUTHOR-in-at32psif-serio-driver-to-val.pat; filename*1=ch
Content-Type: application/mbox; name=0001-Change-MODULE_AUTHOR-in-at32psif-serio-driver-to-val.patch
Content-Transfer-Encoding: 7bit

>From 8a3056b55d3268a03b932830c79b242c5f264ced Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date: Mon, 21 Apr 2008 15:30:55 +0200
Subject: [PATCH 1/1] Change MODULE_AUTHOR in at32psif serio driver to valid email address

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/input/serio/at32psif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
index e49747a..78acab7 100644
--- a/drivers/input/serio/at32psif.c
+++ b/drivers/input/serio/at32psif.c
@@ -302,6 +302,6 @@ static void __exit psif_exit(void)
 module_init(psif_init);
 module_exit(psif_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
 MODULE_LICENSE("GPL");
-- 
1.5.4.3


--=-V86+Swls0hF2VHdwNq8T--


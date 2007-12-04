Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbXLDIPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbXLDIPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLDIPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:15:08 -0500
Received: from www.tglx.de ([62.245.132.106]:53525 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXLDIPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:15:06 -0500
Subject: Re: [PATCH][AT91] Fix compile error for at91rm9200 in latest git
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: Andrew Victor <avictor.za@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <cd73a99e0712031202u71efc0e1g8cf910760475bb5d@mail.gmail.com>
References: <1196675122.3832.18.camel@bender.lan>
	 <200712031053.43316.david-b@pacbell.net>
	 <cd73a99e0712031202u71efc0e1g8cf910760475bb5d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 09:14:29 +0100
Message-Id: <1196756069.3835.7.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> > Your patch looks correct, and seems to be the only obvious chunk
> > that's missing.  So, I'll ack it FWIW ... usual policy for these
> > patches is to go through Russell.
> 
> You can add my Ack for what it's worth.

OK, CC'ed Russell and added your Acked-by.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Acked-by: Andrew Victor <avictor.za@gmail.com>

---
diff --git a/arch/arm/mach-at91/board-ek.c b/arch/arm/mach-at91/board-ek.c
index d05b1b2..53a5ef9 100644
--- a/arch/arm/mach-at91/board-ek.c
+++ b/arch/arm/mach-at91/board-ek.c
@@ -109,6 +109,15 @@ static struct spi_board_info ek_spi_devices[] = {
 #endif
 };
 
+static struct i2c_board_info __initdata ek_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("ics1523", 0x26),
+	},
+	{
+		I2C_BOARD_INFO("dac3550", 0x4d),
+	}
+};
+
 #define EK_FLASH_BASE	AT91_CHIPSELECT_0
 #define EK_FLASH_SIZE	0x200000
 



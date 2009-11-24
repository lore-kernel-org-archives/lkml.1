Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbZKXOOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbZKXOOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbZKXOOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:14:05 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:51985 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbZKXOOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:14:03 -0500
Date: Tue, 24 Nov 2009 15:12:50 +0100
From: Anisse Astier <anisse@astier.eu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Input: i8042 - add Dell Vostro 1520 and 1720 to the reset
 list
Message-ID: <20091124151250.03e185d1@destiny.ordissimo>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These laptops may have i8042 in a bad state at very first boot or if you plug
in a non-Dell power supply.
Thus this patch is needed for proper keyboard and touchpad function.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index a537925..7d1cebc 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -447,6 +447,20 @@ static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
 		},
 	},
+	{
+		.ident = "Dell Vostro 1520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
+		},
+	},
+	{
+		.ident = "Dell Vostro 1720",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.5.2


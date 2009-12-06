Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZLFUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZLFUzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbZLFUzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:55:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbZLFUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:55:43 -0500
Date: Sun, 6 Dec 2009 21:55:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: HTC Dream: dream is better name for this machine
Message-ID: <20091206205538.GA13811@elf.ucw.cz>
References: <20091206205041.GA12555@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206205041.GA12555@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, previous patch will not apply; I messed the trees. This one
should work.]

---

While few people may know HTC Dream by its codename, it is better to
use name of released hardware in the sources.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
index 21afa85..d238e2c 100644
--- a/arch/arm/mach-msm/board-dream.c
+++ b/arch/arm/mach-msm/board-dream.c
@@ -12,6 +12,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * This machine is also known by its codename, "trout".
  */
 
 #include <linux/kernel.h>
@@ -40,12 +41,12 @@ static struct platform_device *devices[] __initdata = {
 
 extern struct sys_timer msm_timer;
 
-static void __init trout_init_irq(void)
+static void __init dream_init_irq(void)
 {
 	msm_init_irq();
 }
 
-static void __init trout_fixup(struct machine_desc *desc, struct tag *tags,
+static void __init dream_fixup(struct machine_desc *desc, struct tag *tags,
 				char **cmdline, struct meminfo *mi)
 {
 	mi->nr_banks = 1;
@@ -54,12 +55,12 @@ static void __init trout_fixup(struct machine_desc *desc, struct tag *tags,
 	mi->bank[0].size = (101*1024*1024);
 }
 
-static void __init trout_init(void)
+static void __init dream_init(void)
 {
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
-static struct map_desc trout_io_desc[] __initdata = {
+static struct map_desc dream_io_desc[] __initdata = {
 	{
 		.virtual = TROUT_CPLD_BASE,
 		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
@@ -68,10 +69,10 @@ static struct map_desc trout_io_desc[] __initdata = {
 	}
 };
 
-static void __init trout_map_io(void)
+static void __init dream_map_io(void)
 {
 	msm_map_common_io();
-	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
+	iotable_init(dream_io_desc, ARRAY_SIZE(dream_io_desc));
 
 #ifdef CONFIG_MSM_DEBUG_UART3
 	/* route UART3 to the "H2W" extended usb connector */
@@ -85,9 +86,9 @@ MACHINE_START(TROUT, "HTC Dream")
 	.phys_io	= MSM_DEBUG_UART_PHYS,
 	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
 	.boot_params	= 0x10000100,
-	.fixup		= trout_fixup,
-	.map_io		= trout_map_io,
-	.init_irq	= trout_init_irq,
-	.init_machine	= trout_init,
+	.fixup		= dream_fixup,
+	.map_io		= dream_map_io,
+	.init_irq	= dream_init_irq,
+	.init_machine	= dream_init,
 	.timer		= &msm_timer,
 MACHINE_END

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

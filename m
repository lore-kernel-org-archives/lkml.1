Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbZEKWn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbZEKWn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZEKWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:43:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZEKWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:43:12 -0400
Message-Id: <200905112243.10011.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:43:09 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [PATCH] arm: rename CLOCK_TICK_RATE to ARM_TICK_RATE
Content-Disposition: inline
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Bs8uYgoKLhxP1kG6Ppj20mSDANvAUQrYCy5+
 4vnJnlEHp96IwfuBd3xKV6os/WnaWrH1kw/7OpNZyQfn7w6r7l
 Bvq2O1yi6YERB3AdDGPmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the users of CLOCK_TICK_RATE in the kernel outside
of ARM assume that it refers to the i8253 base frequency
of 1.193182 Mhz, while in ARM it actually is the clock
frequency of the timer.

By renaming it to ARM_TICK_RATE for all arm specific
device drivers, we can hopefully reduce the amount
of confusion slightly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-aaec2000/include/mach/timex.h   |    2 +-
 arch/arm/mach-at91/include/mach/timex.h       |   16 ++++++++--------
 arch/arm/mach-clps711x/include/mach/timex.h   |    2 +-
 arch/arm/mach-clps711x/time.c                 |    2 +-
 arch/arm/mach-davinci/include/mach/timex.h    |    2 +-
 arch/arm/mach-ebsa110/include/mach/timex.h    |    2 +-
 arch/arm/mach-ep93xx/core.c                   |    2 +-
 arch/arm/mach-ep93xx/include/mach/timex.h     |    2 +-
 arch/arm/mach-footbridge/include/mach/timex.h |    4 ++--
 arch/arm/mach-gemini/include/mach/timex.h     |    2 +-
 arch/arm/mach-h720x/include/mach/timex.h      |    2 +-
 arch/arm/mach-imx/include/mach/timex.h        |    2 +-
 arch/arm/mach-integrator/include/mach/timex.h |    2 +-
 arch/arm/mach-iop13xx/include/mach/timex.h    |    2 +-
 arch/arm/mach-iop32x/include/mach/timex.h     |    2 +-
 arch/arm/mach-iop33x/include/mach/timex.h     |    2 +-
 arch/arm/mach-ixp2000/include/mach/timex.h    |    2 +-
 arch/arm/mach-ixp23xx/core.c                  |    2 +-
 arch/arm/mach-ixp23xx/include/mach/timex.h    |    2 +-
 arch/arm/mach-ixp4xx/include/mach/timex.h     |    4 ++--
 arch/arm/mach-kirkwood/include/mach/timex.h   |    2 +-
 arch/arm/mach-ks8695/include/mach/timex.h     |    2 +-
 arch/arm/mach-ks8695/time.c                   |    6 +++---
 arch/arm/mach-l7200/include/mach/timex.h      |    2 +-
 arch/arm/mach-lh7a40x/include/mach/timex.h    |    4 ++--
 arch/arm/mach-loki/include/mach/timex.h       |    2 +-
 arch/arm/mach-mmp/include/mach/timex.h        |    2 +-
 arch/arm/mach-mmp/time.c                      |    6 +++---
 arch/arm/mach-msm/include/mach/timex.h        |    2 +-
 arch/arm/mach-mv78xx0/include/mach/timex.h    |    2 +-
 arch/arm/mach-netx/include/mach/timex.h       |    2 +-
 arch/arm/mach-netx/time.c                     |    4 ++--
 arch/arm/mach-ns9xxx/include/mach/timex.h     |    4 ++--
 arch/arm/mach-orion5x/include/mach/timex.h    |    2 +-
 arch/arm/mach-pnx4008/include/mach/timex.h    |    2 +-
 arch/arm/mach-pxa/include/mach/timex.h        |   10 +++++-----
 arch/arm/mach-realview/include/mach/timex.h   |    2 +-
 arch/arm/mach-rpc/include/mach/timex.h        |    2 +-
 arch/arm/mach-s3c24a0/include/mach/timex.h    |    2 +-
 arch/arm/mach-sa1100/include/mach/timex.h     |    2 +-
 arch/arm/mach-sa1100/time.c                   |    2 +-
 arch/arm/mach-shark/include/mach/timex.h      |    2 +-
 arch/arm/mach-versatile/include/mach/timex.h  |    2 +-
 arch/arm/mach-w90x900/include/mach/timex.h    |    4 ++--
 arch/arm/plat-mxc/include/mach/timex.h        |    6 +++---
 arch/arm/plat-omap/include/mach/timex.h       |    6 +++---
 arch/arm/plat-s3c/include/mach/timex.h        |    4 ++--
 drivers/rtc/rtc-pxa.c                         |    2 +-
 drivers/serial/serial_ks8695.c                |    2 +-
 drivers/watchdog/davinci_wdt.c                |    4 ++--
 drivers/watchdog/ks8695_wdt.c                 |    2 +-
 51 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/arch/arm/mach-aaec2000/include/mach/timex.h b/arch/arm/mach-
aaec2000/include/mach/timex.h
index 6c8edf4..80d82de 100644
--- a/arch/arm/mach-aaec2000/include/mach/timex.h
+++ b/arch/arm/mach-aaec2000/include/mach/timex.h
@@ -13,6 +13,6 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-#define CLOCK_TICK_RATE		508000
+#define ARM_TICK_RATE		508000
 
 #endif /* __ASM_ARCH_TIMEX_H */
diff --git a/arch/arm/mach-at91/include/mach/timex.h b/arch/arm/mach-
at91/include/mach/timex.h
index d84c994..86215f1 100644
--- a/arch/arm/mach-at91/include/mach/timex.h
+++ b/arch/arm/mach-at91/include/mach/timex.h
@@ -25,7 +25,7 @@
 
 #if defined(CONFIG_ARCH_AT91RM9200)
 
-#define CLOCK_TICK_RATE		(AT91_SLOW_CLOCK)
+#define ARM_TICK_RATE		(AT91_SLOW_CLOCK)
 
 #elif defined(CONFIG_ARCH_AT91SAM9260)
 
@@ -35,12 +35,12 @@
 #define AT91SAM9_MASTER_CLOCK	99300000
 #endif
 
-#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91SAM9261)
 
 #define AT91SAM9_MASTER_CLOCK	99300000
-#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91SAM9263)
 
@@ -50,27 +50,27 @@
 #define AT91SAM9_MASTER_CLOCK	99959500
 #endif
 
-#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91SAM9RL)
 
 #define AT91SAM9_MASTER_CLOCK	100000000
-#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91SAM9G20)
 
 #define AT91SAM9_MASTER_CLOCK	132096000
-#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91CAP9)
 
 #define AT91CAP9_MASTER_CLOCK	100000000
-#define CLOCK_TICK_RATE		(AT91CAP9_MASTER_CLOCK/16)
+#define ARM_TICK_RATE		(AT91CAP9_MASTER_CLOCK/16)
 
 #elif defined(CONFIG_ARCH_AT91X40)
 
 #define AT91X40_MASTER_CLOCK	40000000
-#define CLOCK_TICK_RATE		(AT91X40_MASTER_CLOCK)
+#define ARM_TICK_RATE		(AT91X40_MASTER_CLOCK)
 
 #endif
 
diff --git a/arch/arm/mach-clps711x/include/mach/timex.h b/arch/arm/mach-
clps711x/include/mach/timex.h
index ac8823c..0965041 100644
--- a/arch/arm/mach-clps711x/include/mach/timex.h
+++ b/arch/arm/mach-clps711x/include/mach/timex.h
@@ -20,4 +20,4 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define CLOCK_TICK_RATE 512000
+#define ARM_TICK_RATE 512000
diff --git a/arch/arm/mach-clps711x/time.c b/arch/arm/mach-clps711x/time.c
index d581ef0..e5daed0 100644
--- a/arch/arm/mach-clps711x/time.c
+++ b/arch/arm/mach-clps711x/time.c
@@ -34,7 +34,7 @@
 /*
  * gettimeoffset() returns time since last timer tick, in usecs.
  *
- * 'LATCH' is hwclock ticks (see CLOCK_TICK_RATE in timex.h) per jiffy.
+ * 'LATCH' is hwclock ticks (see ARM_TICK_RATE in timex.h) per jiffy.
  * 'tick' is usecs per jiffy.
  */
 static unsigned long clps711x_gettimeoffset(void)
diff --git a/arch/arm/mach-davinci/include/mach/timex.h b/arch/arm/mach-
davinci/include/mach/timex.h
index 5282756..38314d3 100644
--- a/arch/arm/mach-davinci/include/mach/timex.h
+++ b/arch/arm/mach-davinci/include/mach/timex.h
@@ -12,6 +12,6 @@
 #define __ASM_ARCH_TIMEX_H
 
 /* The source frequency for the timers is the 27MHz clock */
-#define CLOCK_TICK_RATE 27000000
+#define ARM_TICK_RATE 27000000
 
 #endif /* __ASM_ARCH_TIMEX_H__ */
diff --git a/arch/arm/mach-ebsa110/include/mach/timex.h b/arch/arm/mach-
ebsa110/include/mach/timex.h
index 4fb43b2..e0e6623 100644
--- a/arch/arm/mach-ebsa110/include/mach/timex.h
+++ b/arch/arm/mach-ebsa110/include/mach/timex.h
@@ -15,5 +15,5 @@
  * This is therefore not used to calculate the
  * divisor.
  */
-#define CLOCK_TICK_RATE		47894000
+#define ARM_TICK_RATE		47894000
 
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index ae24486..22279b6 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -98,7 +98,7 @@ void __init ep93xx_map_io(void)
  */
 static unsigned int last_jiffy_time;
 
-#define TIMER4_TICKS_PER_JIFFY		((CLOCK_TICK_RATE + (HZ/2)) / HZ)
+#define TIMER4_TICKS_PER_JIFFY		((ARM_TICK_RATE + (HZ/2)) / HZ)
 
 static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
 {
diff --git a/arch/arm/mach-ep93xx/include/mach/timex.h b/arch/arm/mach-
ep93xx/include/mach/timex.h
index 6b3503b..d157204 100644
--- a/arch/arm/mach-ep93xx/include/mach/timex.h
+++ b/arch/arm/mach-ep93xx/include/mach/timex.h
@@ -2,4 +2,4 @@
  * arch/arm/mach-ep93xx/include/mach/timex.h
  */
 
-#define CLOCK_TICK_RATE		983040
+#define ARM_TICK_RATE		983040
diff --git a/arch/arm/mach-footbridge/include/mach/timex.h b/arch/arm/mach-
footbridge/include/mach/timex.h
index d0fea9d..20534ac 100644
--- a/arch/arm/mach-footbridge/include/mach/timex.h
+++ b/arch/arm/mach-footbridge/include/mach/timex.h
@@ -12,7 +12,7 @@
 
 /*
  * We assume a constant here; this satisfies the maths in linux/timex.h
- * and linux/time.h.  CLOCK_TICK_RATE is actually system dependent, but
+ * and linux/time.h.  ARM_TICK_RATE is actually system dependent, but
  * this must be a constant.
  */
-#define CLOCK_TICK_RATE		(50000000/16)
+#define ARM_TICK_RATE		(50000000/16)
diff --git a/arch/arm/mach-gemini/include/mach/timex.h b/arch/arm/mach-
gemini/include/mach/timex.h
index dc5690b..b0eec31 100644
--- a/arch/arm/mach-gemini/include/mach/timex.h
+++ b/arch/arm/mach-gemini/include/mach/timex.h
@@ -10,4 +10,4 @@
  */
 
 /* When AHB bus frequency is 150MHz */
-#define CLOCK_TICK_RATE	38000000
+#define ARM_TICK_RATE	38000000
diff --git a/arch/arm/mach-h720x/include/mach/timex.h b/arch/arm/mach-
h720x/include/mach/timex.h
index 3f2f447..ebe075c 100644
--- a/arch/arm/mach-h720x/include/mach/timex.h
+++ b/arch/arm/mach-h720x/include/mach/timex.h
@@ -10,6 +10,6 @@
 #ifndef __ASM_ARCH_TIMEX
 #define __ASM_ARCH_TIMEX
 
-#define CLOCK_TICK_RATE		3686400
+#define ARM_TICK_RATE		3686400
 
 #endif
diff --git a/arch/arm/mach-imx/include/mach/timex.h b/arch/arm/mach-
imx/include/mach/timex.h
index e22ba78..1e1ef9c 100644
--- a/arch/arm/mach-imx/include/mach/timex.h
+++ b/arch/arm/mach-imx/include/mach/timex.h
@@ -21,6 +21,6 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-#define CLOCK_TICK_RATE		(16000000)
+#define ARM_TICK_RATE		(16000000)
 
 #endif
diff --git a/arch/arm/mach-integrator/include/mach/timex.h b/arch/arm/mach-
integrator/include/mach/timex.h
index 1dcb420..4c06d90 100644
--- a/arch/arm/mach-integrator/include/mach/timex.h
+++ b/arch/arm/mach-integrator/include/mach/timex.h
@@ -23,4 +23,4 @@
 /*
  * ??
  */
-#define CLOCK_TICK_RATE		(50000000 / 16)
+#define ARM_TICK_RATE		(50000000 / 16)
diff --git a/arch/arm/mach-iop13xx/include/mach/timex.h b/arch/arm/mach-
iop13xx/include/mach/timex.h
index 45fb274..4e8d4e6 100644
--- a/arch/arm/mach-iop13xx/include/mach/timex.h
+++ b/arch/arm/mach-iop13xx/include/mach/timex.h
@@ -1 +1 @@
-#define CLOCK_TICK_RATE (100 * HZ)
+#define ARM_TICK_RATE (100 * HZ)
diff --git a/arch/arm/mach-iop32x/include/mach/timex.h b/arch/arm/mach-
iop32x/include/mach/timex.h
index 7262ab8..5ead7ca 100644
--- a/arch/arm/mach-iop32x/include/mach/timex.h
+++ b/arch/arm/mach-iop32x/include/mach/timex.h
@@ -3,4 +3,4 @@
  *
  * IOP32x architecture timex specifications
  */
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
diff --git a/arch/arm/mach-iop33x/include/mach/timex.h b/arch/arm/mach-
iop33x/include/mach/timex.h
index 54c5890..e925e77 100644
--- a/arch/arm/mach-iop33x/include/mach/timex.h
+++ b/arch/arm/mach-iop33x/include/mach/timex.h
@@ -3,4 +3,4 @@
  *
  * IOP3xx architecture timex specifications
  */
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
diff --git a/arch/arm/mach-ixp2000/include/mach/timex.h b/arch/arm/mach-
ixp2000/include/mach/timex.h
index 835e659..479cbab 100644
--- a/arch/arm/mach-ixp2000/include/mach/timex.h
+++ b/arch/arm/mach-ixp2000/include/mach/timex.h
@@ -8,6 +8,6 @@
 /*
  * Default clock is 50MHz APB, but platform code can override this
  */
-#define CLOCK_TICK_RATE	50000000
+#define ARM_TICK_RATE	50000000
 
 
diff --git a/arch/arm/mach-ixp23xx/core.c b/arch/arm/mach-ixp23xx/core.c
index aa4c442..aed022b 100644
--- a/arch/arm/mach-ixp23xx/core.c
+++ b/arch/arm/mach-ixp23xx/core.c
@@ -329,7 +329,7 @@ void __init ixp23xx_init_irq(void)
 /*************************************************************************
  * Timer-tick functions for IXP23xx
  *************************************************************************/
-#define CLOCK_TICKS_PER_USEC	(CLOCK_TICK_RATE / USEC_PER_SEC)
+#define CLOCK_TICKS_PER_USEC	(ARM_TICK_RATE / USEC_PER_SEC)
 
 static unsigned long next_jiffy_time;
 
diff --git a/arch/arm/mach-ixp23xx/include/mach/timex.h b/arch/arm/mach-
ixp23xx/include/mach/timex.h
index e341e9c..c84435b 100644
--- a/arch/arm/mach-ixp23xx/include/mach/timex.h
+++ b/arch/arm/mach-ixp23xx/include/mach/timex.h
@@ -4,4 +4,4 @@
  * XScale architecture timex specifications
  */
 
-#define CLOCK_TICK_RATE 75000000
+#define ARM_TICK_RATE 75000000
diff --git a/arch/arm/mach-ixp4xx/include/mach/timex.h b/arch/arm/mach-
ixp4xx/include/mach/timex.h
index 89ce3ee..1f5c87b 100644
--- a/arch/arm/mach-ixp4xx/include/mach/timex.h
+++ b/arch/arm/mach-ixp4xx/include/mach/timex.h
@@ -7,9 +7,9 @@
 
 /*
  * We use IXP425 General purpose timer for our timer needs, it runs at 
- * 66.66... MHz. We do a convulted calculation of CLOCK_TICK_RATE b/c the
+ * 66.66... MHz. We do a convulted calculation of ARM_TICK_RATE b/c the
  * timer register ignores the bottom 2 bits of the LATCH value.
  */
 #define FREQ 66666666
-#define CLOCK_TICK_RATE (((FREQ / HZ & ~IXP4XX_OST_RELOAD_MASK) + 1) * HZ)
+#define ARM_TICK_RATE (((FREQ / HZ & ~IXP4XX_OST_RELOAD_MASK) + 1) * HZ)
 
diff --git a/arch/arm/mach-kirkwood/include/mach/timex.h b/arch/arm/mach-
kirkwood/include/mach/timex.h
index c923cd1..67d1e54 100644
--- a/arch/arm/mach-kirkwood/include/mach/timex.h
+++ b/arch/arm/mach-kirkwood/include/mach/timex.h
@@ -6,5 +6,5 @@
  * warranty of any kind, whether express or implied.
  */
 
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
 
diff --git a/arch/arm/mach-ks8695/include/mach/timex.h b/arch/arm/mach-
ks8695/include/mach/timex.h
index 4682e35..83e971b 100644
--- a/arch/arm/mach-ks8695/include/mach/timex.h
+++ b/arch/arm/mach-ks8695/include/mach/timex.h
@@ -15,6 +15,6 @@
 #define __ASM_ARCH_TIMEX_H
 
 /* timers are derived from MCLK, which is 25MHz */
-#define CLOCK_TICK_RATE 25000000
+#define ARM_TICK_RATE 25000000
 
 #endif
diff --git a/arch/arm/mach-ks8695/time.c b/arch/arm/mach-ks8695/time.c
index 69c072c..c51fe85 100644
--- a/arch/arm/mach-ks8695/time.c
+++ b/arch/arm/mach-ks8695/time.c
@@ -55,11 +55,11 @@ static unsigned long ks8695_gettimeoffset (void)
 	} while (elapsed > tick2);
 
 	/* Convert to number of ticks expired (not remaining) */
-	elapsed = (CLOCK_TICK_RATE / HZ) - elapsed;
+	elapsed = (ARM_TICK_RATE / HZ) - elapsed;
 
 	/* Is interrupt pending?  If so, then timer has been reloaded already. */
 	if (intpending)
-		elapsed += (CLOCK_TICK_RATE / HZ);
+		elapsed += (ARM_TICK_RATE / HZ);
 
 	/* Convert ticks to usecs */
 	return (unsigned long)(elapsed * (tick_nsec / 1000)) / LATCH;
@@ -82,7 +82,7 @@ static struct irqaction ks8695_timer_irq = {
 
 static void ks8695_timer_setup(void)
 {
-	unsigned long tmout = CLOCK_TICK_RATE / HZ;
+	unsigned long tmout = ARM_TICK_RATE / HZ;
 	unsigned long tmcon;
 
 	/* disable timer1 */
diff --git a/arch/arm/mach-l7200/include/mach/timex.h b/arch/arm/mach-
l7200/include/mach/timex.h
index ffc96a6..b7ed766 100644
--- a/arch/arm/mach-l7200/include/mach/timex.h
+++ b/arch/arm/mach-l7200/include/mach/timex.h
@@ -17,4 +17,4 @@
  *       rate. The value of HZ in 'param.h' must also
  *       be changed to match below.
  */
-#define CLOCK_TICK_RATE		128
+#define ARM_TICK_RATE		128
diff --git a/arch/arm/mach-lh7a40x/include/mach/timex.h b/arch/arm/mach-
lh7a40x/include/mach/timex.h
index 08028ce..87d3657 100644
--- a/arch/arm/mach-lh7a40x/include/mach/timex.h
+++ b/arch/arm/mach-lh7a40x/include/mach/timex.h
@@ -10,8 +10,8 @@
 
 #include <mach/constants.h>
 
-#define CLOCK_TICK_RATE		(PLL_CLOCK/6/16)
+#define ARM_TICK_RATE		(PLL_CLOCK/6/16)
 
 /*
-#define CLOCK_TICK_RATE		3686400
+#define ARM_TICK_RATE		3686400
 */
diff --git a/arch/arm/mach-loki/include/mach/timex.h b/arch/arm/mach-
loki/include/mach/timex.h
index 9df2109..640b53a 100644
--- a/arch/arm/mach-loki/include/mach/timex.h
+++ b/arch/arm/mach-loki/include/mach/timex.h
@@ -6,6 +6,6 @@
  * warranty of any kind, whether express or implied.
  */
 
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
 
 #define LOKI_TCLK		180000000
diff --git a/arch/arm/mach-mmp/include/mach/timex.h b/arch/arm/mach-
mmp/include/mach/timex.h
index 6cebbd0..dcf8e87 100644
--- a/arch/arm/mach-mmp/include/mach/timex.h
+++ b/arch/arm/mach-mmp/include/mach/timex.h
@@ -6,4 +6,4 @@
  * published by the Free Software Foundation.
  */
 
-#define CLOCK_TICK_RATE		3250000
+#define ARM_TICK_RATE		3250000
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index b03a6ed..c85c1e1 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -183,14 +183,14 @@ void __init timer_init(int irq)
 {
 	timer_config();
 
-	set_tcr2ns_scale(CLOCK_TICK_RATE);
+	set_tcr2ns_scale(ARM_TICK_RATE);
 
-	ckevt.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt.shift);
+	ckevt.mult = div_sc(ARM_TICK_RATE, NSEC_PER_SEC, ckevt.shift);
 	ckevt.max_delta_ns = clockevent_delta2ns(MAX_DELTA, &ckevt);
 	ckevt.min_delta_ns = clockevent_delta2ns(MIN_DELTA, &ckevt);
 	ckevt.cpumask = cpumask_of(0);
 
-	cksrc.mult = clocksource_hz2mult(CLOCK_TICK_RATE, cksrc.shift);
+	cksrc.mult = clocksource_hz2mult(ARM_TICK_RATE, cksrc.shift);
 
 	setup_irq(irq, &timer_irq);
 
diff --git a/arch/arm/mach-msm/include/mach/timex.h b/arch/arm/mach-
msm/include/mach/timex.h
index a62e6b2..4bf65ab 100644
--- a/arch/arm/mach-msm/include/mach/timex.h
+++ b/arch/arm/mach-msm/include/mach/timex.h
@@ -16,6 +16,6 @@
 #ifndef __ASM_ARCH_MSM_TIMEX_H
 #define __ASM_ARCH_MSM_TIMEX_H
 
-#define CLOCK_TICK_RATE		1000000
+#define ARM_TICK_RATE		1000000
 
 #endif
diff --git a/arch/arm/mach-mv78xx0/include/mach/timex.h b/arch/arm/mach-
mv78xx0/include/mach/timex.h
index 0e8c443..c074de8 100644
--- a/arch/arm/mach-mv78xx0/include/mach/timex.h
+++ b/arch/arm/mach-mv78xx0/include/mach/timex.h
@@ -6,4 +6,4 @@
  * warranty of any kind, whether express or implied.
  */
 
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
diff --git a/arch/arm/mach-netx/include/mach/timex.h b/arch/arm/mach-
netx/include/mach/timex.h
index 1120dd0..ea1aa8f 100644
--- a/arch/arm/mach-netx/include/mach/timex.h
+++ b/arch/arm/mach-netx/include/mach/timex.h
@@ -17,4 +17,4 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define CLOCK_TICK_RATE 100000000
+#define ARM_TICK_RATE 100000000
diff --git a/arch/arm/mach-netx/time.c b/arch/arm/mach-netx/time.c
index 82801db..85b0969 100644
--- a/arch/arm/mach-netx/time.c
+++ b/arch/arm/mach-netx/time.c
@@ -152,10 +152,10 @@ static void __init netx_timer_init(void)
 			NETX_GPIO_COUNTER_CTRL(TIMER_CLOCKSOURCE));
 
 	clocksource_netx.mult =
-		clocksource_hz2mult(CLOCK_TICK_RATE, clocksource_netx.shift);
+		clocksource_hz2mult(ARM_TICK_RATE, clocksource_netx.shift);
 	clocksource_register(&clocksource_netx);
 
-	netx_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
+	netx_clockevent.mult = div_sc(ARM_TICK_RATE, NSEC_PER_SEC,
 			netx_clockevent.shift);
 	netx_clockevent.max_delta_ns =
 		clockevent_delta2ns(0xfffffffe, &netx_clockevent);
diff --git a/arch/arm/mach-ns9xxx/include/mach/timex.h b/arch/arm/mach-
ns9xxx/include/mach/timex.h
index 734a8d8..9cd49e8 100644
--- a/arch/arm/mach-ns9xxx/include/mach/timex.h
+++ b/arch/arm/mach-ns9xxx/include/mach/timex.h
@@ -12,9 +12,9 @@
 #define __ASM_ARCH_TIMEX_H
 
 /*
- * value for CLOCK_TICK_RATE stolen from arch/arm/mach-
s3c2410/include/mach/timex.h.
+ * value for ARM_TICK_RATE stolen from arch/arm/mach-
s3c2410/include/mach/timex.h.
  * See there for an explanation.
  */
-#define CLOCK_TICK_RATE         12000000
+#define ARM_TICK_RATE         12000000
 
 #endif /* ifndef __ASM_ARCH_TIMEX_H */
diff --git a/arch/arm/mach-orion5x/include/mach/timex.h b/arch/arm/mach-
orion5x/include/mach/timex.h
index 4c69820..957c434 100644
--- a/arch/arm/mach-orion5x/include/mach/timex.h
+++ b/arch/arm/mach-orion5x/include/mach/timex.h
@@ -8,4 +8,4 @@
  * warranty of any kind, whether express or implied.
  */
 
-#define CLOCK_TICK_RATE		(100 * HZ)
+#define ARM_TICK_RATE		(100 * HZ)
diff --git a/arch/arm/mach-pnx4008/include/mach/timex.h b/arch/arm/mach-
pnx4008/include/mach/timex.h
index 5ff0196..b0faff3 100644
--- a/arch/arm/mach-pnx4008/include/mach/timex.h
+++ b/arch/arm/mach-pnx4008/include/mach/timex.h
@@ -17,7 +17,7 @@
 #include <linux/io.h>
 #include <mach/hardware.h>
 
-#define CLOCK_TICK_RATE		1000000
+#define ARM_TICK_RATE		1000000
 
 #define TICKS2USECS(x)	(x)
 
diff --git a/arch/arm/mach-pxa/include/mach/timex.h b/arch/arm/mach-
pxa/include/mach/timex.h
index af6760a..337fdac 100644
--- a/arch/arm/mach-pxa/include/mach/timex.h
+++ b/arch/arm/mach-pxa/include/mach/timex.h
@@ -10,7 +10,7 @@
  * published by the Free Software Foundation.
  */
 
-/* Various drivers are still using the constant of CLOCK_TICK_RATE, for
+/* Various drivers are still using the constant of ARM_TICK_RATE, for
  * those drivers to at least work, the definition is provided here.
  *
  * NOTE: this is no longer accurate when multiple processors and boards
@@ -21,14 +21,14 @@
 
 #if defined(CONFIG_PXA25x)
 /* PXA250/210 timer base */
-#define CLOCK_TICK_RATE 3686400
+#define ARM_TICK_RATE 3686400
 #elif defined(CONFIG_PXA27x)
 /* PXA27x timer base */
 #ifdef CONFIG_MACH_MAINSTONE
-#define CLOCK_TICK_RATE 3249600
+#define ARM_TICK_RATE 3249600
 #else
-#define CLOCK_TICK_RATE 3250000
+#define ARM_TICK_RATE 3250000
 #endif
 #else
-#define CLOCK_TICK_RATE 3250000
+#define ARM_TICK_RATE 3250000
 #endif
diff --git a/arch/arm/mach-realview/include/mach/timex.h b/arch/arm/mach-
realview/include/mach/timex.h
index 4eeb069..adcfee9 100644
--- a/arch/arm/mach-realview/include/mach/timex.h
+++ b/arch/arm/mach-realview/include/mach/timex.h
@@ -20,4 +20,4 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define CLOCK_TICK_RATE		(50000000 / 16)
+#define ARM_TICK_RATE		(50000000 / 16)
diff --git a/arch/arm/mach-rpc/include/mach/timex.h b/arch/arm/mach-
rpc/include/mach/timex.h
index dd75e73..3518567 100644
--- a/arch/arm/mach-rpc/include/mach/timex.h
+++ b/arch/arm/mach-rpc/include/mach/timex.h
@@ -13,5 +13,5 @@
 /*
  * On the RiscPC, the clock ticks at 2MHz.
  */
-#define CLOCK_TICK_RATE		2000000
+#define ARM_TICK_RATE		2000000
 
diff --git a/arch/arm/mach-s3c24a0/include/mach/timex.h b/arch/arm/mach-
s3c24a0/include/mach/timex.h
index 9857342..cb00161 100644
--- a/arch/arm/mach-s3c24a0/include/mach/timex.h
+++ b/arch/arm/mach-s3c24a0/include/mach/timex.h
@@ -13,6 +13,6 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-#define CLOCK_TICK_RATE 12000000
+#define ARM_TICK_RATE 12000000
 
 #endif /* __ASM_ARCH_TIMEX_H */
diff --git a/arch/arm/mach-sa1100/include/mach/timex.h b/arch/arm/mach-
sa1100/include/mach/timex.h
index 7a5d017..d3a4fd0 100644
--- a/arch/arm/mach-sa1100/include/mach/timex.h
+++ b/arch/arm/mach-sa1100/include/mach/timex.h
@@ -9,4 +9,4 @@
 /*
  * SA1100 timer
  */
-#define CLOCK_TICK_RATE		3686400
+#define ARM_TICK_RATE		3686400
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 711c029..a561628 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -112,7 +112,7 @@ static void __init sa1100_timer_init(void)
 	ckevt_sa1100_osmr0.cpumask = cpumask_of(0);
 
 	cksrc_sa1100_oscr.mult =
-		clocksource_hz2mult(CLOCK_TICK_RATE, cksrc_sa1100_oscr.shift);
+		clocksource_hz2mult(ARM_TICK_RATE, cksrc_sa1100_oscr.shift);
 
 	setup_irq(IRQ_OST0, &sa1100_timer_irq);
 
diff --git a/arch/arm/mach-shark/include/mach/timex.h b/arch/arm/mach-
shark/include/mach/timex.h
index bb6eeae..d32920d 100644
--- a/arch/arm/mach-shark/include/mach/timex.h
+++ b/arch/arm/mach-shark/include/mach/timex.h
@@ -4,4 +4,4 @@
  * by Alexander Schulz
  */
 
-#define CLOCK_TICK_RATE 1193180
+#define ARM_TICK_RATE 1193180
diff --git a/arch/arm/mach-versatile/include/mach/timex.h b/arch/arm/mach-
versatile/include/mach/timex.h
index 426199b..07176df 100644
--- a/arch/arm/mach-versatile/include/mach/timex.h
+++ b/arch/arm/mach-versatile/include/mach/timex.h
@@ -20,4 +20,4 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define CLOCK_TICK_RATE		(50000000 / 16)
+#define ARM_TICK_RATE		(50000000 / 16)
diff --git a/arch/arm/mach-w90x900/include/mach/timex.h b/arch/arm/mach-
w90x900/include/mach/timex.h
index 164dce0..906fb72 100644
--- a/arch/arm/mach-w90x900/include/mach/timex.h
+++ b/arch/arm/mach-w90x900/include/mach/timex.h
@@ -18,8 +18,8 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-/* CLOCK_TICK_RATE Now, I don't use it. */
+/* ARM_TICK_RATE Now, I don't use it. */
 
-#define CLOCK_TICK_RATE 15000000
+#define ARM_TICK_RATE 15000000
 
 #endif /* __ASM_ARCH_TIMEX_H */
diff --git a/arch/arm/plat-mxc/include/mach/timex.h b/arch/arm/plat-
mxc/include/mach/timex.h
index 07b4a73..4f8919d 100644
--- a/arch/arm/plat-mxc/include/mach/timex.h
+++ b/arch/arm/plat-mxc/include/mach/timex.h
@@ -21,11 +21,11 @@
 #define __ASM_ARCH_MXC_TIMEX_H__
 
 #if defined CONFIG_ARCH_MX1
-#define CLOCK_TICK_RATE		16000000
+#define ARM_TICK_RATE		16000000
 #elif defined CONFIG_ARCH_MX2
-#define CLOCK_TICK_RATE		13300000
+#define ARM_TICK_RATE		13300000
 #elif defined CONFIG_ARCH_MX3
-#define CLOCK_TICK_RATE		16625000
+#define ARM_TICK_RATE		16625000
 #endif
 
 #endif				/* __ASM_ARCH_MXC_TIMEX_H__ */
diff --git a/arch/arm/plat-omap/include/mach/timex.h b/arch/arm/plat-
omap/include/mach/timex.h
index 6d35767..d572956 100644
--- a/arch/arm/plat-omap/include/mach/timex.h
+++ b/arch/arm/plat-omap/include/mach/timex.h
@@ -30,12 +30,12 @@
 
 /*
  * OMAP 32KHz timer updates time one jiffie at a time from a secondary timer,
- * and that's why the CLOCK_TICK_RATE is not 32768.
+ * and that's why the ARM_TICK_RATE is not 32768.
  */
 #ifdef CONFIG_OMAP_32K_TIMER
-#define CLOCK_TICK_RATE		(CONFIG_OMAP_32K_TIMER_HZ)
+#define ARM_TICK_RATE		(CONFIG_OMAP_32K_TIMER_HZ)
 #else
-#define CLOCK_TICK_RATE		(HZ * 100000UL)
+#define ARM_TICK_RATE		(HZ * 100000UL)
 #endif
 
 #endif /* __ASM_ARCH_OMAP_TIMEX_H */
diff --git a/arch/arm/plat-s3c/include/mach/timex.h b/arch/arm/plat-
s3c/include/mach/timex.h
index 2a425ed..a32574a 100644
--- a/arch/arm/plat-s3c/include/mach/timex.h
+++ b/arch/arm/plat-s3c/include/mach/timex.h
@@ -13,14 +13,14 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-/* CLOCK_TICK_RATE needs to be evaluatable by the cpp, so making it
+/* ARM_TICK_RATE needs to be evaluatable by the cpp, so making it
  * a variable is useless. It seems as long as we make our timers an
  * exact multiple of HZ, any value that makes a 1->1 correspondence
  * for the time conversion functions to/from jiffies is acceptable.
 */
 
 
-#define CLOCK_TICK_RATE 12000000
+#define ARM_TICK_RATE 12000000
 
 
 #endif /* __ASM_ARCH_TIMEX_H */
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index bb8cc05..22133f4 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -29,7 +29,7 @@
 
 #include <mach/hardware.h>
 
-#define TIMER_FREQ		CLOCK_TICK_RATE
+#define TIMER_FREQ		ARM_TICK_RATE
 #define RTC_DEF_DIVIDER		(32768 - 1)
 #define RTC_DEF_TRIM		0
 #define MAXFREQ_PERIODIC	1000
diff --git a/drivers/serial/serial_ks8695.c b/drivers/serial/serial_ks8695.c
index 998e89d..5d66a2f 100644
--- a/drivers/serial/serial_ks8695.c
+++ b/drivers/serial/serial_ks8695.c
@@ -549,7 +549,7 @@ static struct uart_port ks8695uart_ports[SERIAL_KS8695_NR] 
= {
 		.mapbase	= KS8695_UART_VA,
 		.iotype		= SERIAL_IO_MEM,
 		.irq		= KS8695_IRQ_UART_TX,
-		.uartclk	= CLOCK_TICK_RATE * 16,
+		.uartclk	= ARM_TICK_RATE * 16,
 		.fifosize	= 16,
 		.ops		= &ks8695uart_pops,
 		.flags		= ASYNC_BOOT_AUTOCONF,
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index c51d0b0..de7f784 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -99,9 +99,9 @@ static void wdt_enable(void)
 	iowrite32(0, wdt_base + TIM12);
 	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
+	timer_margin = (((u64)heartbeat * ARM_TICK_RATE) & 0xffffffff);
 	iowrite32(timer_margin, wdt_base + PRD12);
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
+	timer_margin = (((u64)heartbeat * ARM_TICK_RATE) >> 32);
 	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
 	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index ae38321..4594e93 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -66,7 +66,7 @@ static inline void ks8695_wdt_stop(void)
 static inline void ks8695_wdt_start(void)
 {
 	unsigned long tmcon;
-	unsigned long tval = wdt_time * CLOCK_TICK_RATE;
+	unsigned long tval = wdt_time * ARM_TICK_RATE;
 
 	spin_lock(&ks8695_lock);
 	/* disable timer0 */
-- 
1.6.0.4

-- 



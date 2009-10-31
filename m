Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZJaJli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZJaJli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbZJaJlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:37 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35835 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZJaJle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lcMlcbOKdoVruABuzT6JHcviu463FkDs/85k3+6twc5ujBDiISIsPdzDWFyHnZNMEg
         sjNMOLyFnxkrEwMAA7A+mloR8bjhyeEHLzqQhmS5zaKH1nxlKE3qW7hxGwipQ2vWRlUm
         AIPn/wpZpdKmWshlhWWV8jfDfVVgMwr9IZUOQ=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:19 -0200
Message-ID: <b8bf37780910310241r3ef056a1j6862c5c1a430e29a@mail.gmail.com>
Subject: [PATCH 08/16] trivial: fix assorted "reasonable" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 77d3ac4e747551b7806b2349d4021d0a512a4449 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:53:17 -0200
Subject: [PATCH 08/16] trivial: fix assorted "reasonable" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index fb8a06b..67e7a78 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -145,7 +145,7 @@ struct bi_record {

     /*
      *  Macintosh hardware profile data - unused, see macintosh.h for
-     *  resonable type values
+     *  reasonable type values
      */

 #define BI_MAC_VIA1BASE		0x8010	/* Mac VIA1 base address (always present) */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e20bca..ab02d21 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1286,7 +1286,7 @@ x86_perf_event_set_period(struct perf_event *event,
 		return 0;

 	/*
-	 * If we are way outside a reasoable range then just skip forward:
+	 * If we are way outside a reasonable range then just skip forward:
 	 */
 	if (unlikely(left <= -period)) {
 		left = period;
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 99b74a3..941a4d3 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1360,7 +1360,7 @@ static struct mmc_host_ops s3cmci_ops = {

 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
-	 * checks. Any zero fields to ensure reaonable defaults are picked. */
+	 * checks. Any zero fields to ensure reasonable defaults are picked. */
 };

 #ifdef CONFIG_CPU_FREQ
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 4e6359f..0680251 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1633,8 +1633,13 @@ static int amd8111e_enable_link_change(struct
amd8111e_priv* lp)
 	readl(lp->mmio + CMD7);
 	return 0;
 }
-/* This function is called when a packet transmission fails to
complete within a  resonable period, on the assumption that an
interrupts have been failed or the  interface is locked up. This
function will reinitialize the hardware */

+/*
+ * This function is called when a packet transmission fails to complete
+ * within a reasonable period, on the assumption that an interrupts
+ * have been failed or the  interface is locked up. This function will
+ * reinitialize the hardware
+ */
 static void amd8111e_tx_timeout(struct net_device *dev)
 {
 	struct amd8111e_priv* lp = netdev_priv(dev);
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 30f5161..2985eb4 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -462,7 +462,7 @@ static struct cmb_area cmb_area = {
  * block of memory, which can not be moved as long as any channel
  * is active. Therefore, a maximum number of subchannels needs to
  * be defined somewhere. This is a module parameter, defaulting to
- * a resonable value of 1024, or 32 kb of memory.
+ * a reasonable value of 1024, or 32 kb of memory.
  * Current kernels don't allow kmalloc with more than 128kb, so the
  * maximum is 4096.
  */
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 1366be1..7f96713 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -6495,7 +6495,7 @@ static void ncr_int_ma (struct ncb *np)
 	**	we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids
 	**	bloat for such a should_not_happen situation).
 	**	In all other situation, we reset the BUS.
-	**	Are these assumptions reasonnable ? (Wait and see ...)
+	**	Are these assumptions reasonable ? (Wait and see ...)
 	*/
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c
b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..a7bc8b7 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2692,7 +2692,7 @@ static void sym_int_ma (struct sym_hcb *np)
 	 *  we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids
 	 *  bloat for such a should_not_happen situation).
 	 *  In all other situation, we reset the BUS.
-	 *  Are these assumptions reasonnable ? (Wait and see ...)
+	 *  Are these assumptions reasonable ? (Wait and see ...)
 	 */
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h
b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 053e63c..5a80cba 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -54,7 +54,7 @@
  *
  *    SYM_OPT_LIMIT_COMMAND_REORDERING
  *        When this option is set, the driver tries to limit tagged
- *        command reordering to some reasonnable value.
+ *        command reordering to some reasonable value.
  *        (set for Linux)
  */
 #if 0
diff --git a/drivers/staging/rtl8187se/r8185b_init.c
b/drivers/staging/rtl8187se/r8185b_init.c
index cd07059..bdb66d8 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2493,8 +2493,8 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	PhyConfig8185(dev);

 	// We assume RegWirelessMode has already been initialized before,
-	// however, we has to validate the wireless mode here and provide a reasonble
-	// initialized value if necessary. 2005.01.13, by rcnjko.
+	// however, we has to validate the wireless mode here and provide a
+	// reasonable initialized value if necessary. 2005.01.13, by rcnjko.
 	SupportedWirelessMode = GetSupportedWirelessMode8185(dev);
 	if(	(ieee->mode != WIRELESS_MODE_B) &&
 		(ieee->mode != WIRELESS_MODE_G) &&
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6e23035..ff8ef5c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -117,7 +117,7 @@ config HEADERS_CHECK
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
 	# This option is on purpose disabled for now.
-	# It will be enabled when we are down to a resonable number
+	# It will be enabled when we are down to a reasonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
-- 
1.6.5.2.101.gcd0f8

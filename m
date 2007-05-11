Return-Path: <linux-kernel-owner+w=401wt.eu-S966447AbXEKTqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966447AbXEKTqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763487AbXEKTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:42:13 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45949 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763456AbXEKTmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:42:10 -0400
Message-ID: <4644C70E.1010902@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:42:06 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/m68k/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/m68k/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/m68k/amiga/pcmcia.c    |    2 +-
 arch/m68k/mac/config.c      |    4 ++--
 arch/m68k/mac/iop.c         |    4 ++--
 arch/m68k/mac/oss.c         |    2 +-
 arch/m68k/mac/via.c         |    2 +-
 arch/m68k/math-emu/fp_log.c |    2 +-
 arch/m68k/q40/q40ints.c     |    4 ++--
 arch/m68k/sun3/mmu_emu.c    |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/amiga/pcmcia.c b/arch/m68k/amiga/pcmcia.c
index fc57c6e..186662c 100644
--- a/arch/m68k/amiga/pcmcia.c
+++ b/arch/m68k/amiga/pcmcia.c
@@ -33,7 +33,7 @@ void pcmcia_reset(void)
 
 
 /* copy a tuple, including tuple header. return nb bytes copied */
-/* be carefull as this may trigger a GAYLE_IRQ_WR interrupt ! */
+/* be careful as this may trigger a GAYLE_IRQ_WR interrupt ! */
 
 int pcmcia_copy_tuple(unsigned char tuple_id, void *tuple, int max_len)
 {
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 5fd4132..f40eecd 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -283,7 +283,7 @@ static struct mac_model mac_data_table[] = {
 	},
 
 	/*
-	 *	Weirdified MacII hardware - all subtley different. Gee thanks
+	 *	Weirdified MacII hardware - all subtly different. Gee thanks
 	 *	Apple. All these boxes seem to have VIA2 in a different place to
 	 *	the MacII (+1A000 rather than +4000)
 	 * CSA: see http://developer.apple.com/technotes/hw/hw_09.html
@@ -706,7 +706,7 @@ static struct mac_model mac_data_table[] = {
 	 * All of these probably have onboard SONIC in the Dock which
 	 * means we'll have to probe for it eventually.
 	 *
-	 * Are these reallly MAC_VIA_IIci? The developer notes for the
+	 * Are these really MAC_VIA_IIci? The developer notes for the
 	 * Duos show pretty much the same custom parts as in most of
 	 * the other PowerBooks which would imply MAC_VIA_QUADRA.
 	 */
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 0cea21f..5b2799e 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -100,7 +100,7 @@
  * finished; this function moves the message state to MSG_COMPLETE and signals
  * the IOP. This two-step process is provided to allow the handler to defer
  * message processing to a bottom-half handler if the processing will take
- * a signifigant amount of time (handlers are called at interrupt time so they
+ * a significant amount of time (handlers are called at interrupt time so they
  * should execute quickly.)
  */
 
@@ -120,7 +120,7 @@
 
 /*#define DEBUG_IOP*/
 
-/* Set to nonezero if the IOPs are present. Set by iop_init() */
+/* Set to non-zero if the IOPs are present. Set by iop_init() */
 
 int iop_scc_present,iop_ism_present;
 
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index d7be169..50603d3 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -8,7 +8,7 @@
  *
  * 990502 (jmt) - Major rewrite for new interrupt architecture as well as some
  *		  recent insights into OSS operational details.
- * 990610 (jmt) - Now taking fulll advantage of the OSS. Interrupts are mapped
+ * 990610 (jmt) - Now taking full advantage of the OSS. Interrupts are mapped
  *		  to mostly match the A/UX interrupt scheme supported on the
  *		  VIA side. Also added support for enabling the ISM irq again
  *		  since we now have a functional IOP manager.
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index d5cac72..8df270e 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -1,7 +1,7 @@
 /*
  *	6522 Versatile Interface Adapter (VIA)
  *
- *	There are two of these on the Mac II. Some IRQ's are vectored
+ *	There are two of these on the Mac II. Some IRQs are vectored
  *	via them as are assorted bits and bobs - eg RTC, ADB.
  *
  * CSA: Motorola seems to have removed documentation on the 6522 from
diff --git a/arch/m68k/math-emu/fp_log.c b/arch/m68k/math-emu/fp_log.c
index 87b4f01..b1033ae 100644
--- a/arch/m68k/math-emu/fp_log.c
+++ b/arch/m68k/math-emu/fp_log.c
@@ -65,7 +65,7 @@ fp_fsqrt(struct fp_ext *dest, struct fp_ext *src)
 	fp_copy_ext(&src2, dest);
 
 	/*
-	 * The taylor row arround a for sqrt(x) is:
+	 * The taylor row around a for sqrt(x) is:
 	 *	sqrt(x) = sqrt(a) + 1/(2*sqrt(a))*(x-a) + R
 	 * With a=1 this gives:
 	 *	sqrt(x) = 1 + 1/2*(x-1)
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 2fb25ae..bbf626e 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -184,7 +184,7 @@ static struct IRQ_TABLE eirqs[] = {
 };
 
 /* complain only this many times about spurious ints : */
-static int ccleirq=60;    /* ISA dev IRQ's*/
+static int ccleirq=60;    /* ISA dev IRQs*/
 /*static int cclirq=60;*/     /* internal */
 
 /* FIXME: add shared ints,mask,unmask,probing.... */
@@ -234,7 +234,7 @@ static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
  * There is a little mess wrt which IRQ really caused this irq request. The
  * main problem is that IIRQ_REG and EIRQ_REG reflect the state when they
  * are read - which is long after the request came in. In theory IRQs should
- * not just go away but they occassionally do
+ * not just go away but they occasionally do
  */
 				if (irq > 4 && irq <= 15 && mext_disabled) {
 					/*aliased_irq++;*/
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 7a0e3a2..fb0f6a2 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -239,7 +239,7 @@ void clear_context(unsigned long context)
 /* gets an empty context.  if full, kills the next context listed to
    die first */
 /* This context invalidation scheme is, well, totally arbitrary, I'm
-   sure it could be much more intellegent...  but it gets the job done
+   sure it could be much more intelligent...  but it gets the job done
    for now without much overhead in making it's decision. */
 /* todo: come up with optimized scheme for flushing contexts */
 unsigned long get_free_context(struct mm_struct *mm)
-- 
1.5.0.1

-- 
Simon Arlott

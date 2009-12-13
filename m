Return-Path: <linux-kernel-owner+w=401wt.eu-S1750987AbZLMGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbZLMGzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 01:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbZLMGzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 01:55:43 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:52238 "HELO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730AbZLMGzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 01:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=D7uUyWGR3OzDDkcvzG+n5eG7AUv1Zr/YHP9ef6H6VWUZdeh6pTKxftuTLSith1t9X3
         XM8NGkPUQ1ARzrnJS7P8WGFkIUmmagEX2uwHCJgcEVBgawpQFHYFekrziE7lKtX1LU8A
         CLgXd8Z2tYMGU6pWXDz7qXf8iD4mSJc5OXE30=
MIME-Version: 1.0
Date: Sun, 13 Dec 2009 14:55:40 +0800
Message-ID: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
Subject: [PATCH v2]kernel: remove mess codes
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some mess characters(0x0c) in the kernel source code.
Then I suggest remove it.
Thanks for Toralf Förster's support.
This patch include the following 40 files:

./include/linux/a.out.h
./sound/isa/wavefront/wavefront_synth.c
./arch/powerpc/xmon/spu-opc.c
./arch/powerpc/xmon/ppc-opc.c
./arch/powerpc/xmon/ppc.h
./arch/xtensa/lib/memcopy.S
./arch/sparc/lib/COPYING.LIB
./arch/alpha/kernel/core_marvel.c
./arch/alpha/kernel/sys_marvel.c
./arch/alpha/kernel/core_lca.c
./arch/alpha/kernel/sys_titan.c
./arch/alpha/kernel/core_apecs.c
./arch/alpha/kernel/err_titan.c
./arch/alpha/kernel/err_common.c
./arch/alpha/kernel/entry.S
./arch/alpha/kernel/core_wildfire.c
./arch/alpha/kernel/smc37c669.c
./arch/alpha/kernel/core_titan.c
./arch/alpha/kernel/srmcons.c
./arch/alpha/kernel/core_cia.c
./arch/alpha/kernel/core_polaris.c
./arch/alpha/kernel/pci_iommu.c
./arch/alpha/kernel/core_mcpcia.c
./arch/alpha/kernel/core_t2.c
./arch/alpha/kernel/smp.c
./arch/alpha/kernel/core_tsunami.c
./arch/alpha/kernel/core_irongate.c
./arch/ia64/kernel/unwind.c
./arch/m68k/atari/stram.c
./drivers/media/video/zoran/videocodec.h
./drivers/net/wan/cosa.c
./drivers/net/usb/usbnet.c
./drivers/net/usb/cdc_subset.c
./drivers/scsi/st.c
./drivers/scsi/osst.c
./Documentation/scsi/FlashPoint.txt
./COPYING
./scripts/kconfig/zconf.tab.c_shipped
./scripts/genksyms/parse.c_shipped
./scripts/dtc/dtc-parser.tab.c_shipped
----
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Signed-off-by: Toralf Förster<toralf.foerster@gmx.de>
----
diff --git a/COPYING b/COPYING
index ca442d3..0dde99b 100644
--- a/COPYING
+++ b/COPYING
@@ -71,7 +71,7 @@ patent must be licensed for everyone's free use or
not licensed at all.

   The precise terms and conditions for copying, distribution and
 modification follow.
-
+
 		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

@@ -126,7 +126,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-
+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -184,7 +184,7 @@ access to copy from a designated place, then
offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-
+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -241,7 +241,7 @@ impose that choice.

 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-
+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -294,7 +294,7 @@ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS
BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.

 		     END OF TERMS AND CONDITIONS
-
+
 	    How to Apply These Terms to Your New Programs

   If you develop a new program, and you want it to be of the greatest
diff --git a/Documentation/scsi/FlashPoint.txt
b/Documentation/scsi/FlashPoint.txt
index d5acaa3..3272276 100644
--- a/Documentation/scsi/FlashPoint.txt
+++ b/Documentation/scsi/FlashPoint.txt
@@ -60,7 +60,7 @@ Vice President of Marketing
 Mylex Corp.
 510/796-6100
 peters@mylex.com
-
+
 			       ANNOUNCEMENT
 	       BusLogic FlashPoint LT/BT-948 Upgrade Program
 			      1 February 1996
diff --git a/arch/alpha/kernel/core_apecs.c b/arch/alpha/kernel/core_apecs.c
index ca46b2c..89e8276 100644
--- a/arch/alpha/kernel/core_apecs.c
+++ b/arch/alpha/kernel/core_apecs.c
@@ -310,7 +310,7 @@ struct pci_ops apecs_pci_ops =
 	.read =		apecs_read_config,
 	.write =	apecs_write_config,
 };
-
+
 void
 apecs_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -318,7 +318,7 @@ apecs_pci_tbi(struct pci_controller *hose,
dma_addr_t start, dma_addr_t end)
 	*(vip)APECS_IOC_TBIA = 0;
 	mb();
 }
-
+
 void __init
 apecs_init_arch(void)
 {
diff --git a/arch/alpha/kernel/core_cia.c b/arch/alpha/kernel/core_cia.c
index 1d6ee6c..88c6efe 100644
--- a/arch/alpha/kernel/core_cia.c
+++ b/arch/alpha/kernel/core_cia.c
@@ -244,7 +244,7 @@ struct pci_ops cia_pci_ops =
 	.read = 	cia_read_config,
 	.write =	cia_write_config,
 };
-
+
 /*
  * CIA Pass 1 and PYXIS Pass 1 and 2 have a broken scatter-gather tlb.
  * It cannot be invalidated.  Rather than hard code the pass numbers,
@@ -553,7 +553,7 @@ failed:
 	alpha_mv.mv_pci_tbi = NULL;
 	goto exit;
 }
-
+
 #if defined(ALPHA_RESTORE_SRM_SETUP)
 /* Save CIA configuration data as the console had it set up.  */
 struct
@@ -624,7 +624,7 @@ cia_restore_srm_settings(void)
 #define cia_restore_srm_settings()	do {} while (0)
 #endif /* ALPHA_RESTORE_SRM_SETUP */

-
+
 static void __init
 do_init_arch(int is_pyxis)
 {
diff --git a/arch/alpha/kernel/core_irongate.c
b/arch/alpha/kernel/core_irongate.c
index a872078..29a28ad 100644
--- a/arch/alpha/kernel/core_irongate.c
+++ b/arch/alpha/kernel/core_irongate.c
@@ -160,7 +160,7 @@ struct pci_ops irongate_pci_ops =
 	.read =		irongate_read_config,
 	.write =	irongate_write_config,
 };
-
+
 int
 irongate_pci_clr_err(void)
 {
diff --git a/arch/alpha/kernel/core_lca.c b/arch/alpha/kernel/core_lca.c
index 4843f6e..dd36457 100644
--- a/arch/alpha/kernel/core_lca.c
+++ b/arch/alpha/kernel/core_lca.c
@@ -236,7 +236,7 @@ struct pci_ops lca_pci_ops =
 	.read =		lca_read_config,
 	.write =	lca_write_config,
 };
-
+
 void
 lca_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -244,7 +244,7 @@ lca_pci_tbi(struct pci_controller *hose,
dma_addr_t start, dma_addr_t end)
 	*(vulp)LCA_IOC_TBIA = 0;
 	mb();
 }
-
+
 void __init
 lca_init_arch(void)
 {
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 53dd2f1..c50b861 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -30,7 +30,7 @@
 #include "proto.h"
 #include "pci_impl.h"

-
+
 /*
  * Debug helpers
  */
@@ -42,13 +42,13 @@
 # define DBG_CFG(args)
 #endif

-
+
 /*
  * Private data
  */
 static struct io7 *io7_head = NULL;

-
+
 /*
  * Helper functions
  */
@@ -192,7 +192,7 @@ io7_clear_errors(struct io7 *io7)
 	p7csrs->PO7_CRRCT_SYM.csr = -1UL;
 }

-
+
 /*
  * IO7 PCI, PCI/X, AGP configuration.
  */
@@ -466,7 +466,7 @@ marvel_kill_arch(int mode)
 {
 }

-
+
 /*
  * PCI Configuration Space access functions
  *
@@ -594,7 +594,7 @@ struct pci_ops marvel_pci_ops =
 	.write = 	marvel_write_config,
 };

-
+
 /*
  * Other PCI helper functions.
  */
@@ -609,8 +609,8 @@ marvel_pci_tbi(struct pci_controller *hose,
dma_addr_t start, dma_addr_t end)
 	csrs->POx_SG_TBIA.csr;
 }

-
-
+
+
 /*
  * RTC Support
  */
@@ -671,7 +671,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 	return ret;
 }

-
+
 /*
  * IO map support.
  */
@@ -836,7 +836,7 @@ EXPORT_SYMBOL(marvel_ioportmap);
 EXPORT_SYMBOL(marvel_ioread8);
 EXPORT_SYMBOL(marvel_iowrite8);
 #endif
-
+
 /*
  * NUMA Support
  */
@@ -881,7 +881,7 @@ marvel_node_mem_size(int nid)
 	return 16UL * 1024 * 1024 * 1024; /* 16GB */
 }

-
+
 /*
  * AGP GART Support.
  */
diff --git a/arch/alpha/kernel/core_mcpcia.c b/arch/alpha/kernel/core_mcpcia.c
index 381fec0..807cd3a 100644
--- a/arch/alpha/kernel/core_mcpcia.c
+++ b/arch/alpha/kernel/core_mcpcia.c
@@ -240,7 +240,7 @@ struct pci_ops mcpcia_pci_ops =
 	.read =		mcpcia_read_config,
 	.write =	mcpcia_write_config,
 };
-
+
 void
 mcpcia_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -248,7 +248,7 @@ mcpcia_pci_tbi(struct pci_controller *hose,
dma_addr_t start, dma_addr_t end)
 	*(vuip)MCPCIA_SG_TBIA(MCPCIA_HOSE2MID(hose->index)) = 0;
 	mb();
 }
-
+
 static int __init
 mcpcia_probe_hose(int h)
 {
diff --git a/arch/alpha/kernel/core_polaris.c b/arch/alpha/kernel/core_polaris.c
index c5a271d..9153575 100644
--- a/arch/alpha/kernel/core_polaris.c
+++ b/arch/alpha/kernel/core_polaris.c
@@ -141,7 +141,7 @@ struct pci_ops polaris_pci_ops =
 	.read =		polaris_read_config,
 	.write =	polaris_write_config,
 };
-
+
 void __init
 polaris_init_arch(void)
 {
diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index e6d9056..73ff647 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -321,7 +321,7 @@ struct pci_ops t2_pci_ops =
 	.read =		t2_read_config,
 	.write =	t2_write_config,
 };
-
+
 static void __init
 t2_direct_map_window1(unsigned long base, unsigned long length)
 {
diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 219bf27..c9a4a5f 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -52,7 +52,7 @@ static int titan_pchip1_present;
 # define DBG_CFG(args)
 #endif

-
+
 /*
  * Routines to access TIG registers.
  */
@@ -76,7 +76,7 @@ titan_write_tig(int offset, u8 value)
 	*tig_addr = (unsigned long)value;
 }

-
+
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address
@@ -197,7 +197,7 @@ struct pci_ops titan_pci_ops =
 	.write =	titan_write_config,
 };

-
+
 void
 titan_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -436,7 +436,7 @@ titan_kill_arch(int mode)
 	titan_kill_pachips(TITAN_pachip0, TITAN_pachip1);
 }

-
+
 /*
  * IO map support.
  */
@@ -567,7 +567,7 @@ EXPORT_SYMBOL(titan_ioremap);
 EXPORT_SYMBOL(titan_iounmap);
 EXPORT_SYMBOL(titan_is_mmio);
 #endif
-
+
 /*
  * AGP GART Support.
  */
diff --git a/arch/alpha/kernel/core_tsunami.c b/arch/alpha/kernel/core_tsunami.c
index 5e7c28f..dd2f0c3 100644
--- a/arch/alpha/kernel/core_tsunami.c
+++ b/arch/alpha/kernel/core_tsunami.c
@@ -171,7 +171,7 @@ struct pci_ops tsunami_pci_ops =
 	.read =		tsunami_read_config,
 	.write = 	tsunami_write_config,
 };
-
+
 void
 tsunami_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -193,7 +193,7 @@ tsunami_pci_tbi(struct pci_controller *hose,
dma_addr_t start, dma_addr_t end)
 	mb();
 	*csr;
 }
-
+
 #ifdef NXM_MACHINE_CHECKS_ON_TSUNAMI
 static long __init
 tsunami_probe_read(volatile unsigned long *vaddr)
diff --git a/arch/alpha/kernel/core_wildfire.c
b/arch/alpha/kernel/core_wildfire.c
index 7e07244..48aad41 100644
--- a/arch/alpha/kernel/core_wildfire.c
+++ b/arch/alpha/kernel/core_wildfire.c
@@ -437,7 +437,7 @@ struct pci_ops wildfire_pci_ops =
 	.write =	wildfire_write_config,
 };

-
+
 /*
  * NUMA Support
  */
diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index b45d913..11f0bde 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -273,7 +273,7 @@ entDbg:
 	mov	$sp, $16
 	jsr	$31, do_entDbg
 .end entDbg
-
+
 /*
  * The system call entry point is special.  Most importantly, it looks
  * like a function call to userspace as far as clobbered registers.  We
@@ -465,7 +465,7 @@ $strace_error:
 	mov	$31, $26	/* tell "ret_from_sys_call" we can restart */
 	br	ret_from_sys_call
 .end strace
-
+
 /*
  * Save and restore the switch stack -- aka the balance of the user context.
  */
@@ -566,7 +566,7 @@ undo_switch_stack:
 	lda	$sp, SWITCH_STACK_SIZE($sp)
 	ret	$31, ($1), 1
 .end undo_switch_stack
-
+
 /*
  * The meat of the context switch code.
  */
@@ -705,7 +705,7 @@ kernel_execve:
 	ret
 .end kernel_execve

-
+
 /*
  * Special system calls.  Most of these are special in that they either
  * have to play switch_stack games or in some way use the pt_regs struct.
diff --git a/arch/alpha/kernel/err_common.c b/arch/alpha/kernel/err_common.c
index 13d53b1..941edb5 100644
--- a/arch/alpha/kernel/err_common.c
+++ b/arch/alpha/kernel/err_common.c
@@ -23,7 +23,7 @@
  */
 char *err_print_prefix = KERN_NOTICE;

-
+
 /*
  * Generic
  */
@@ -76,7 +76,7 @@ mchk_dump_logout_frame(struct el_common *mchk_header)
 	printk("%s  -- End of Frame --\n", err_print_prefix);
 }

-
+
 /*
  * Console Data Log
  */
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index f7ed97c..f5c2e27 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -577,7 +577,7 @@ titan_register_error_handlers(void)
 	ev6_register_error_handlers();
 }

-
+
 /*
  * Privateer
  */
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 8449504..01ed5ee 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -52,7 +52,7 @@ size_for_memory(unsigned long max)
 		max = roundup_pow_of_two(mem);
 	return max;
 }
-
+
 struct pci_iommu_arena * __init
 iommu_arena_new_node(int nid, struct pci_controller *hose, dma_addr_t base,
 		     unsigned long window_size, unsigned long align)
@@ -216,7 +216,7 @@ iommu_arena_free(struct pci_iommu_arena *arena,
long ofs, long n)
 	for (i = 0; i < n; ++i)
 		p[i] = 0;
 }
-
+
 /* True if the machine supports DAC addressing, and DEV can
    make use of it given MASK.  */
 static int pci_dac_dma_supported(struct pci_dev *hwdev, u64 mask);
@@ -820,7 +820,7 @@ pci_dma_supported(struct pci_dev *pdev, u64 mask)
 }
 EXPORT_SYMBOL(pci_dma_supported);

-
+
 /*
  * AGP GART extensions to the IOMMU
  */
diff --git a/arch/alpha/kernel/smc37c669.c b/arch/alpha/kernel/smc37c669.c
index bca5bda..4077d10 100644
--- a/arch/alpha/kernel/smc37c669.c
+++ b/arch/alpha/kernel/smc37c669.c
@@ -1105,7 +1105,7 @@ static int SMC37c669_xlate_drq(
 );

 static  __cacheline_aligned DEFINE_SPINLOCK(smc_lock);
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1201,7 +1201,7 @@ SMC37c669_CONFIG_REGS * __init SMC37c669_detect(
int index )
     return SMC37c669;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1433,7 +1433,7 @@ unsigned int __init SMC37c669_enable_device (
unsigned int func )
     return ret_val;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1637,7 +1637,7 @@ unsigned int __init SMC37c669_disable_device (
unsigned int func )
     return ret_val;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1714,7 +1714,7 @@ unsigned int __init SMC37c669_configure_device (
     return FALSE;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1801,7 +1801,7 @@ static unsigned int __init
SMC37c669_is_device_enabled ( unsigned int func )
     return ret_val;
 }

-
+
 #if 0
 /*
 **++
@@ -1873,7 +1873,7 @@ static unsigned int __init SMC37c669_get_device_config (
 }
 #endif

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1950,7 +1950,7 @@ void __init SMC37c669_display_device_info ( void )
     }
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1993,7 +1993,7 @@ static void __init SMC37c669_config_mode(
     	wb( &SMC37c669->index_port, SMC37c669_CONFIG_OFF_KEY );
     }
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2026,7 +2026,7 @@ static unsigned char __init SMC37c669_read_config(
     data = rb( &SMC37c669->data_port );
     return data;
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2061,7 +2061,7 @@ static void __init SMC37c669_write_config(
     wb( &SMC37c669->data_port, data );
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2190,7 +2190,7 @@ static void __init SMC37c669_init_local_config ( void )
     local_config[IDE_0].irq = 14;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2237,7 +2237,7 @@ static struct DEVICE_CONFIG * __init
SMC37c669_get_config( unsigned int func )
     }
     return cp;
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2289,7 +2289,7 @@ static int __init SMC37c669_xlate_irq ( int irq )
     return translated_irq;
 }

-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2340,7 +2340,7 @@ static int __init SMC37c669_xlate_drq ( int drq )
     }
     return translated_drq;
 }
-
+
 #if 0
 int __init smcc669_init ( void )
 {
@@ -2355,7 +2355,7 @@ int __init smcc669_init ( void )

     return msg_success;
 }
-
+
 int __init smcc669_open( struct FILE *fp, char *info, char *next, char *mode )
 {
     struct INODE *ip;
@@ -2380,7 +2380,7 @@ int __init smcc669_open( struct FILE *fp, char
*info, char *next, char *mode )

     return msg_success;
 }
-
+
 int __init smcc669_close( struct FILE *fp )
 {
     struct INODE *ip;
@@ -2393,7 +2393,7 @@ int __init smcc669_close( struct FILE *fp )
     }
     return msg_success;
 }
-
+
 int __init smcc669_read( struct FILE *fp, int size, int number,
unsigned char *buf )
 {
     int i;
@@ -2419,7 +2419,7 @@ int __init smcc669_read( struct FILE *fp, int
size, int number, unsigned char *b
     SMC37c669_config_mode( FALSE );
     return nbytes;
 }
-
+
 int __init smcc669_write( struct FILE *fp, int size, int number,
unsigned char *buf )
 {
     int i;
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 42aa078..a285ed8 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -511,7 +511,7 @@ smp_cpus_done(unsigned int max_cpus)
 	       ((bogosum + 2500) / (5000/HZ)) % 100);
 }

-
+
 void
 smp_percpu_timer_interrupt(struct pt_regs *regs)
 {
@@ -546,7 +546,7 @@ setup_profiling_timer(unsigned int multiplier)
 	return -EINVAL;
 }

-
+
 static void
 send_ipi_message(const struct cpumask *to_whom, enum ipi_message_type
operation)
 {
diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 783f4e5..4ccb123 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -268,7 +268,7 @@ srmcons_init(void)

 module_init(srmcons_init);

-
+
 /*
  * The console driver
  */
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 0bb3b5c..c16966c 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -35,7 +35,7 @@
 # error NR_IRQS < MARVEL_NR_IRQS !!!
 #endif

-
+
 /*
  * Interrupt handling.
  */
@@ -511,7 +511,7 @@ marvel_smp_callin(void)
 	for (i = 0; i < 16; ++i)
 		io7_redirect_one_msi(io7, i, cpuid);
 }
-
+
 /*
  * System Vectors
  */
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 2880533..6d76c63 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -37,7 +37,7 @@
 #include "machvec_impl.h"
 #include "err_impl.h"

-
+
 /*
  * Titan generic
  */
@@ -268,7 +268,7 @@ titan_dispatch_irqs(u64 mask)
 	}
 }

-
+
 /*
  * Titan Family
  */
@@ -349,7 +349,7 @@ titan_init_pci(void)
 	locate_and_init_vga(NULL);
 }

-
+
 /*
  * Privateer
  */
@@ -371,7 +371,7 @@ privateer_init_pci(void)
 	return titan_init_pci();
 }

-
+
 /*
  * The System Vectors.
  */
diff --git a/arch/ia64/kernel/unwind.c b/arch/ia64/kernel/unwind.c
index b6c0e63..ff130e2 100644
--- a/arch/ia64/kernel/unwind.c
+++ b/arch/ia64/kernel/unwind.c
@@ -609,7 +609,7 @@ unw_access_pr (struct unw_frame_info *info,
unsigned long *val, int write)
 }
 EXPORT_SYMBOL(unw_access_pr);

-
+
 /* Routines to manipulate the state stack.  */

 static inline void
@@ -674,7 +674,7 @@ free_state_stack (struct unw_reg_state *rs)
 	}
 	rs->next = NULL;
 }
-
+
 /* Unwind decoder routines */

 static enum unw_register_index __attribute_const__
@@ -1198,7 +1198,7 @@ desc_spill_sprel_p (unsigned char qp, unw_word
t, unsigned char abreg, unw_word

 #include "unwind_decoder.c"

-
+
 /* Unwind scripts. */

 static inline unw_hash_index_t
diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index 6ec3b7f..0886821 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -111,7 +111,7 @@ static int remove_region( BLOCK *block );

 /************************* End of Prototypes **************************/

-
+
 /* ------------------------------------------------------------------------ */
 /*							   Public Interface								*/
 /* ------------------------------------------------------------------------ */
@@ -241,7 +241,7 @@ void atari_stram_free( void *addr )
 }
 EXPORT_SYMBOL(atari_stram_free);

-
+
 /* ------------------------------------------------------------------------ */
 /*							  Region Management								*/
 /* ------------------------------------------------------------------------ */
@@ -317,7 +317,7 @@ static int remove_region( BLOCK *block )
 }


-
+
 /* ------------------------------------------------------------------------ */
 /*						 /proc statistics file stuff						*/
 /* ------------------------------------------------------------------------ */
diff --git a/arch/powerpc/xmon/ppc-opc.c b/arch/powerpc/xmon/ppc-opc.c
index af3780e..880f80f 100644
--- a/arch/powerpc/xmon/ppc-opc.c
+++ b/arch/powerpc/xmon/ppc-opc.c
@@ -38,7 +38,7 @@
    This file also holds the operand table.  All knowledge about
    inserting operands into instructions and vice-versa is kept in this
    file.  */
-
+
 /* Local insertion and extraction functions.  */

 static unsigned long insert_bat (unsigned long, long, int, const char **);
@@ -97,7 +97,7 @@ static unsigned long insert_ev4 (unsigned long,
long, int, const char **);
 static long extract_ev4 (unsigned long, int, int *);
 static unsigned long insert_ev8 (unsigned long, long, int, const char **);
 static long extract_ev8 (unsigned long, int, int *);
-
+
 /* The operands table.

    The fields are bits, shift, insert, extract, flags.
@@ -1515,7 +1515,7 @@ extract_tbr (unsigned long insn,
     ret = 0;
   return ret;
 }
-
+
 /* Macros used to form opcodes.  */

 /* The main opcode.  */
@@ -1870,7 +1870,7 @@ extract_tbr (unsigned long insn,
 #define TONG	(0x14)
 #define TONE	(0x18)
 #define TOU	(0x1f)
-
+
 /* Smaller names for the flags so each entry in the opcodes table will
    fit on a single line.  */
 #undef	PPC
@@ -1911,7 +1911,7 @@ extract_tbr (unsigned long insn,
 #define PPCCHLK	PPC_OPCODE_CACHELCK
 #define PPCCHLK64	PPC_OPCODE_CACHELCK | PPC_OPCODE_BOOKE64
 #define PPCRFMCI	PPC_OPCODE_RFMCI
-
+
 /* The opcode table.

    The format of the opcode table is:
@@ -4934,7 +4934,7 @@ const struct powerpc_opcode powerpc_opcodes[] = {
 };

 const int powerpc_num_opcodes = ARRAY_SIZE(powerpc_opcodes);
-
+
 /* The macro table.  This is only used by the assembler.  */

 /* The expressions of the form (-x ! 31) & (x | 31) have the value 0
diff --git a/arch/powerpc/xmon/ppc.h b/arch/powerpc/xmon/ppc.h
index 110df96..e46bf47 100644
--- a/arch/powerpc/xmon/ppc.h
+++ b/arch/powerpc/xmon/ppc.h
@@ -148,7 +148,7 @@ extern const int powerpc_num_opcodes;

 /* A macro to extract the major opcode from an instruction.  */
 #define PPC_OP(i) (((i) >> 26) & 0x3f)
-
+
 /* The operands table is an array of struct powerpc_operand.  */

 struct powerpc_operand
@@ -292,7 +292,7 @@ extern const struct powerpc_operand powerpc_operands[];

 /* This operand is for the DQ field in a DQ form instruction.  */
 #define PPC_OPERAND_DQ (0100000)
-
+
 /* The POWER and PowerPC assemblers use a few macros.  We keep them
    with the operands table for simplicity.  The macro table is an
    array of struct powerpc_macro.  */
diff --git a/arch/powerpc/xmon/spu-opc.c b/arch/powerpc/xmon/spu-opc.c
index 530df3d..b0b385a 100644
--- a/arch/powerpc/xmon/spu-opc.c
+++ b/arch/powerpc/xmon/spu-opc.c
@@ -22,7 +22,7 @@
 #include "spu.h"

 /* This file holds the Spu opcode table */
-
+

 /*
    Example contents of spu-insn.h
diff --git a/arch/sparc/lib/COPYING.LIB b/arch/sparc/lib/COPYING.LIB
index eb685a5..8c8377d 100644
--- a/arch/sparc/lib/COPYING.LIB
+++ b/arch/sparc/lib/COPYING.LIB
@@ -51,7 +51,7 @@ library.  If the library is modified by someone else
and passed on, we
 want its recipients to know that what they have is not the original
 version, so that any problems introduced by others will not reflect on
 the original authors' reputations.
-
+
   Finally, any free program is threatened constantly by software
 patents.  We wish to avoid the danger that companies distributing free
 software will individually obtain patent licenses, thus in effect
@@ -98,7 +98,7 @@ works together with the library.

   Note that it is possible for a library to be covered by the ordinary
 General Public License rather than by this special one.
-
+
 		  GNU LIBRARY GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

@@ -145,7 +145,7 @@ Library.
   You may charge a fee for the physical act of transferring a copy,
 and you may at your option offer warranty protection in exchange for a
 fee.
-
+
   2. You may modify your copy or copies of the Library or any portion
 of it, thus forming a work based on the Library, and copy and
 distribute such modifications or work under the terms of Section 1
@@ -203,7 +203,7 @@ instead of to this License.  (If a newer version
than version 2 of the
 ordinary GNU General Public License has appeared, then you can specify
 that version instead if you wish.)  Do not make any other change in
 these notices.
-
+
   Once this change is made in a given copy, it is irreversible for
 that copy, so the ordinary GNU General Public License applies to all
 subsequent copies and derivative works made from that copy.
@@ -254,7 +254,7 @@ Library will still fall under Section 6.)
 distribute the object code for the work under the terms of Section 6.
 Any executables containing that work also fall under Section 6,
 whether or not they are linked directly with the Library itself.
-
+
   6. As an exception to the Sections above, you may also compile or
 link a "work that uses the Library" with the Library to produce a
 work containing portions of the Library, and distribute that work
@@ -308,7 +308,7 @@ restrictions of other proprietary libraries that
do not normally
 accompany the operating system.  Such a contradiction means you cannot
 use both them and the Library together in an executable that you
 distribute.
-
+
   7. You may place library facilities that are a work based on the
 Library side-by-side in a single library together with other library
 facilities not covered by this License, and distribute such a combined
@@ -349,7 +349,7 @@ subject to these terms and conditions.  You may
not impose any further
 restrictions on the recipients' exercise of the rights granted herein.
 You are not responsible for enforcing compliance by third parties to
 this License.
-
+
   11. If, as a consequence of a court judgment or allegation of patent
 infringement or for any other reason (not limited to patent issues),
 conditions are imposed on you (whether by court order, agreement or
@@ -401,7 +401,7 @@ conditions either of that version or of any later
version published by
 the Free Software Foundation.  If the Library does not specify a
 license version number, you may choose any version ever published by
 the Free Software Foundation.
-
+
   14. If you wish to incorporate parts of the Library into other free
 programs whose distribution conditions are incompatible with these,
 write to the author to ask for permission.  For software which is
@@ -435,7 +435,7 @@ SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH
 DAMAGES.

 		     END OF TERMS AND CONDITIONS
-
+
      Appendix: How to Apply These Terms to Your New Libraries

   If you develop a new library, and you want it to be of the greatest
diff --git a/arch/xtensa/lib/memcopy.S b/arch/xtensa/lib/memcopy.S
index ea59dcd..dee39c2 100644
--- a/arch/xtensa/lib/memcopy.S
+++ b/arch/xtensa/lib/memcopy.S
@@ -305,7 +305,7 @@ memmove:
 	l8ui	a6, a3,  0
 	s8i	a6, a5,  0
 	retw
-
+
 /*
  * Local Variables:
  * mode:fundamental
diff --git a/drivers/media/video/zoran/videocodec.h
b/drivers/media/video/zoran/videocodec.h
index 5c27b25..d3fe9c8 100644
--- a/drivers/media/video/zoran/videocodec.h
+++ b/drivers/media/video/zoran/videocodec.h
@@ -68,7 +68,7 @@
    device dependent and vary between MJPEG/MPEG/WAVELET/... devices. (!!!!)
    ----------------------------------------------------------------------------
 */
-
+

 /* ========================================== */
 /* description of the videocodec_io structure */
@@ -115,7 +115,7 @@
 		the calls include frame numbers and flags (even/odd/...)
 		if needed and a flag which allows blocking until its ready
 */
-
+
 /* ============== */
 /* user interface */
 /* ============== */
@@ -135,7 +135,7 @@ M                       zr36055[0] 0001 0000c001
00000000 (zr36050[0])
 M                       zr36055[1] 0001 0000c001 00000000 (zr36050[1])

 */
-
+

 /* =============================================== */
 /* special defines for the videocodec_io structure */
@@ -214,7 +214,7 @@ M                       zr36055[1] 0001 0000c001
00000000 (zr36050[1])
 /*  -> used in get_image, put_image                                        */
 #define CODEC_TRANSFER_KERNEL 0	/* use "memcopy" */
 #define CODEC_TRANSFER_USER   1	/* use "to/from_user" */
-
+

 /* ========================= */
 /* the structures itself ... */
@@ -328,7 +328,7 @@ struct videocodec_master {
 			  __u16 reg,
 			  __u32 value);
 };
-
+

 /* ================================================= */
 /* function prototypes of the master/slave interface */
diff --git a/drivers/net/usb/cdc_subset.c b/drivers/net/usb/cdc_subset.c
index ca39ace..3fd7752 100644
--- a/drivers/net/usb/cdc_subset.c
+++ b/drivers/net/usb/cdc_subset.c
@@ -93,7 +93,7 @@ static const struct driver_info	ali_m5632_info = {

 #endif

-
+
 #ifdef	CONFIG_USB_AN2720
 #define	HAVE_HARDWARE

@@ -118,7 +118,7 @@ static const struct driver_info	an2720_info = {

 #endif	/* CONFIG_USB_AN2720 */

-
+
 #ifdef	CONFIG_USB_BELKIN
 #define	HAVE_HARDWARE

@@ -137,7 +137,7 @@ static const struct driver_info	belkin_info = {
 #endif	/* CONFIG_USB_BELKIN */


-
+
 #ifdef	CONFIG_USB_EPSON2888
 #define	HAVE_HARDWARE

@@ -163,7 +163,7 @@ static const struct driver_info	epson2888_info = {

 #endif	/* CONFIG_USB_EPSON2888 */

-
+
 /*-------------------------------------------------------------------------
  *
  * info from Jonathan McDowell <noodles@earth.li>
@@ -176,7 +176,7 @@ static const struct driver_info kc2190_info = {
 };
 #endif /* CONFIG_USB_KC2190 */

-
+
 #ifdef	CONFIG_USB_ARMLINUX
 #define	HAVE_HARDWARE

@@ -214,7 +214,7 @@ static const struct driver_info	blob_info = {

 #endif	/* CONFIG_USB_ARMLINUX */

-
+
 /*-------------------------------------------------------------------------*/

 #ifndef	HAVE_HARDWARE
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 035fab0..a7eef8e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -252,7 +252,7 @@ void usbnet_skb_return (struct usbnet *dev, struct
sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(usbnet_skb_return);

-
+
 /*-------------------------------------------------------------------------
  *
  * Network Device Driver (peer link to "Host Device", from USB host)
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index b36bf96..c947d18 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -623,7 +623,7 @@ err_out:
 	return err;
 }

-
+
 /*---------- network device ---------- */

 static int cosa_net_attach(struct net_device *dev, unsigned short encoding,
@@ -1006,7 +1006,7 @@ static int cosa_fasync(struct inode *inode,
struct file *file, int on)
 }
 #endif

-
+
 /* ---------- Ioctls ---------- */

 /*
@@ -1219,7 +1219,7 @@ static long cosa_chardev_ioctl(struct file
*file, unsigned int cmd,
 	return ret;
 }

-
+
 /*---------- HW layer interface ---------- */

 /*
@@ -1394,7 +1394,7 @@ static int cosa_dma_able(struct channel_data
*chan, char *buf, int len)
 	return 1;
 }

-
+
 /* ---------- The SRP/COSA ROM monitor functions ---------- */

 /*
@@ -1564,7 +1564,7 @@ static int cosa_reset_and_read_id(struct
cosa_data *cosa, char *idstring)
 	return id;
 }

-
+
 /* ---------- Auxiliary routines for COSA/SRP monitor ---------- */

 /*
@@ -1649,7 +1649,7 @@ static int puthexnumber(struct cosa_data *cosa,
int number)
 	return 0;
 }

-
+
 /* ---------- Interrupt routines ---------- */

 /*
@@ -1998,7 +1998,7 @@ again:
 	return IRQ_HANDLED;
 }

-
+
 /* ---------- I/O debugging routines ---------- */
 /*
  * These routines can be used to monitor COSA/SRP I/O and to printk()
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..e01455f 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -194,7 +194,7 @@ static inline char *tape_name(struct osst_tape *tape)
 {
 	return tape->drive->disk_name;
 }
-
+
 /* Routines that handle the interaction with mid-layer SCSI routines */


@@ -540,7 +540,7 @@ static void osst_write_behind_check(struct osst_tape *STp)
 }


-
+
 /* Onstream specific Routines */
 /*
  * Initialize the OnStream AUX
@@ -3042,7 +3042,7 @@ static int osst_write_trailer(struct osst_tape
*STp, struct osst_request ** aSRp
 out:
 	return result;
 }
-
+
 /* osst versions of st functions - augmented and stripped to suit
OnStream only */

 /* Flush the write buffer (never need to write if variable blocksize). */
@@ -3358,7 +3358,7 @@ static void reset_state(struct osst_tape *STp)
 	}
 }
 				
-
+
 /* Entry points to osst */

 /* Write command */
@@ -5281,7 +5281,7 @@ static long osst_compat_ioctl(struct file *
file, unsigned int cmd_in, unsigned
 #endif


-
+
 /* Memory handling routines */

 /* Try to allocate a new tape buffer skeleton. Caller must not hold
os_scsi_tapes_lock */
@@ -5548,7 +5548,7 @@ static int osst_copy_from_buffer(struct
osst_buffer *st_bp, unsigned char *ptr)
 	return 0;
 }

-
+
 /* Module housekeeping */

 static void validate_options (void)
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ad59abb..325058f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -222,7 +222,7 @@ static void scsi_tape_release(struct kref *);

 static DEFINE_MUTEX(st_ref_mutex);

-
+
 #include "osst_detect.h"
 #ifndef SIGS_FROM_OSST
 #define SIGS_FROM_OSST \
@@ -302,7 +302,7 @@ static char * st_incompatible(struct scsi_device* SDp)
 		}
 	return NULL;
 }
-
+

 static inline char *tape_name(struct scsi_tape *tape)
 {
@@ -805,7 +805,7 @@ static int flush_buffer(struct scsi_tape *STp, int
seek_next)
 	return result;

 }
-
+
 /* Set the mode parameters */
 static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 {
@@ -884,7 +884,7 @@ static void reset_state(struct scsi_tape *STp)
 		STp->new_partition = STp->partition;
 	}
 }
-
+
 /* Test if the drive is ready. Returns either one of the codes below
or a negative system
    error code. */
 #define CHKRES_READY       0
@@ -1167,7 +1167,7 @@ static int check_tape(struct scsi_tape *STp,
struct file *filp)
 }


-/* Open the device. Needs to take the BKL only because of
incrementing the SCSI host
+/* Open the device. Needs to take the BKL only because of
incrementing the SCSI host
    module count. */
 static int st_open(struct inode *inode, struct file *filp)
 {
@@ -1257,7 +1257,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	return retval;

 }
-
+

 /* Flush the tape buffer before close */
 static int st_flush(struct file *filp, fl_owner_t id)
@@ -1390,7 +1390,7 @@ static int st_release(struct inode *inode,
struct file *filp)

 	return result;
 }
-
+
 /* The checks common to both reading and writing */
 static ssize_t rw_checks(struct scsi_tape *STp, struct file *filp,
size_t count)
 {
@@ -1808,7 +1808,7 @@ st_write(struct file *filp, const char __user
*buf, size_t count, loff_t * ppos)

 	return retval;
 }
-
+
 /* Read data from the tape. Returns zero in the normal case, one if the
    eof status has changed, and the negative error code in case of a
    fatal error. Otherwise updates the buffer and the eof state.
@@ -1999,7 +1999,7 @@ static long read_tape(struct scsi_tape *STp, long count,
 	}
 	return retval;
 }
-
+

 /* Read command */
 static ssize_t
@@ -2147,7 +2147,7 @@ st_read(struct file *filp, char __user *buf,
size_t count, loff_t * ppos)

 	return retval;
 }
-
+


 DEB(
@@ -2346,7 +2346,7 @@ static int st_set_options(struct scsi_tape *STp,
long options)

 	return 0;
 }
-
+
 #define MODE_HEADER_LENGTH  4

 /* Mode header and page byte offsets */
@@ -2568,7 +2568,7 @@ static int do_load_unload(struct scsi_tape *STp,
struct file *filp, int load_cod

 	return retval;
 }
-
+
 #if DEBUG
 #define ST_DEB_FORWARD  0
 #define ST_DEB_BACKWARD 1
@@ -2979,7 +2979,7 @@ static int st_int_ioctl(struct scsi_tape *STp,
unsigned int cmd_in, unsigned lon

 	return ioctl_result;
 }
-
+

 /* Get the tape position. If bt == 2, arg points into a kernel space mt_loc
    structure. */
@@ -3173,7 +3173,7 @@ static int switch_partition(struct scsi_tape *STp)
 		STps->last_block_visited = 0;
 	return set_location(STp, STps->last_block_visited, STp->new_partition, 1);
 }
-
+
 /* Functions for reading and writing the medium partition mode page. */

 #define PART_PAGE   0x11
@@ -3291,7 +3291,7 @@ static int partition_tape(struct scsi_tape *STp, int size)

 	return result;
 }
-
+


 /* The ioctl command */
@@ -3663,7 +3663,7 @@ static long st_compat_ioctl(struct file *file,
unsigned int cmd, unsigned long a
 }
 #endif

-
+

 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index e86dfca..7c41cbd 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -162,7 +162,7 @@ enum machine_type {
 #if !defined (N_BSSADDR)
 #define N_BSSADDR(x) (N_DATADDR(x) + (x).a_data)
 #endif
-
+
 #if !defined (N_NLIST_DECLARED)
 struct nlist {
   union {
@@ -235,7 +235,7 @@ struct nlist {

 /* This is output from LD.  */
 #define N_SETV	0x1C		/* Pointer to set vector in data area.  */
-
+
 #if !defined (N_RELOCATION_INFO_DECLARED)
 /* This structure describes a single relocation to be performed.
    The text-relocation section of the file is a vector of these structures,
diff --git a/scripts/dtc/dtc-parser.tab.c_shipped
b/scripts/dtc/dtc-parser.tab.c_shipped
index 2712937..9243ed0 100644
--- a/scripts/dtc/dtc-parser.tab.c_shipped
+++ b/scripts/dtc/dtc-parser.tab.c_shipped
@@ -891,7 +891,7 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif

-
+

 #if YYERROR_VERBOSE

@@ -1102,7 +1102,7 @@ yysyntax_error (char *yyresult, int yystate, int yychar)
     }
 }
 #endif /* YYERROR_VERBOSE */
-
+

 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1136,7 +1136,7 @@ yydestruct (yymsg, yytype, yyvaluep, yylocationp)
 	break;
     }
 }
-
+

 /* Prevent warnings from -Wmissing-prototypes.  */

diff --git a/scripts/genksyms/parse.c_shipped b/scripts/genksyms/parse.c_shipped
index eaee44e..302875e 100644
--- a/scripts/genksyms/parse.c_shipped
+++ b/scripts/genksyms/parse.c_shipped
@@ -1130,7 +1130,7 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif

-
+

 #if YYERROR_VERBOSE

@@ -1341,7 +1341,7 @@ yysyntax_error (char *yyresult, int yystate, int yychar)
     }
 }
 #endif /* YYERROR_VERBOSE */
-
+

 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1373,7 +1373,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 	break;
     }
 }
-
+

 /* Prevent warnings from -Wmissing-prototypes.  */

diff --git a/scripts/kconfig/zconf.tab.c_shipped
b/scripts/kconfig/zconf.tab.c_shipped
index 6e9dcd5..2afc8d1 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1046,7 +1046,7 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif

-
+

 #if YYERROR_VERBOSE

@@ -1257,7 +1257,7 @@ yysyntax_error (char *yyresult, int yystate, int yychar)
     }
 }
 #endif /* YYERROR_VERBOSE */
-
+

 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
diff --git a/sound/isa/wavefront/wavefront_synth.c
b/sound/isa/wavefront/wavefront_synth.c
index 5d4ff48..7d66674 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -506,7 +506,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 	return 0;
 	
 }
-
+
 /***********************************************************************
 WaveFront data munging

@@ -588,7 +588,7 @@ demunge_buf (unsigned char *src, unsigned char
*dst, unsigned int src_bytes)

 	return dst;
 }
-
+
 /***********************************************************************
 WaveFront: sample, patch and program management.
 ***********************************************************************/
@@ -1451,7 +1451,7 @@ wavefront_load_patch (snd_wavefront_t *dev,
const char __user *addr)
 	kfree(header);
 	return err;
 }
-
+
 /***********************************************************************
 WaveFront: hardware-dependent interface
 ***********************************************************************/
@@ -1684,7 +1684,7 @@ snd_wavefront_synth_ioctl (struct snd_hwdep *hw,
struct file *file,
 	return 0;
 }

-
+
 /***********************************************************************/
 /*  WaveFront: interface for card-level wavefront module               */
 /***********************************************************************/

----

Best Regards,
Liuwenyi
2009-12-13

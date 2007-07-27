Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbXG0Ajt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbXG0Ajt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbXG0Ai7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:38:59 -0400
Received: from rex.snapgear.com ([203.143.235.140]:36583 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933197AbXG0Ai6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:38:58 -0400
Date: Fri, 27 Jul 2007 10:38:16 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707270038.l6R0cGSC006637@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove crap from machdep.h
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused dead crap from machdep.h header.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h linux/include/asm-m68knommu/machdep.h
--- linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h	2007-07-27 10:35:41.000000000 +1000
+++ linux/include/asm-m68knommu/machdep.h	2007-07-27 10:22:04.000000000 +1000
@@ -1,51 +1,20 @@
 #ifndef _M68KNOMMU_MACHDEP_H
 #define _M68KNOMMU_MACHDEP_H
 
-#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
-struct pt_regs;
-struct kbd_repeat;
-struct mktime;
-struct hwclk_time;
-struct gendisk;
-struct buffer_head;
-
 extern void (*mach_sched_init) (irq_handler_t handler);
 
-/* machine dependent keyboard functions */
-extern int (*mach_keyb_init) (void);
-extern int (*mach_kbdrate) (struct kbd_repeat *);
-extern void (*mach_kbd_leds) (unsigned int);
-/* machine dependent irq functions */
-extern void (*mach_init_IRQ) (void);
-extern irq_handler_t mach_default_handler;
-extern int (*mach_request_irq) (unsigned int irq, void (*handler)(int, void *, struct pt_regs *),
-                                unsigned long flags, const char *devname, void *dev_id);
-extern void (*mach_free_irq) (unsigned int irq, void *dev_id);
-extern void (*mach_get_model) (char *model);
-extern int (*mach_get_hardware_list) (char *buffer);
-extern int (*mach_get_irq_list) (struct seq_file *p, void *v);
-extern void (*mach_process_int) (int irq, struct pt_regs *fp);
 /* machine dependent timer functions */
 extern unsigned long (*mach_gettimeoffset)(void);
 extern void (*mach_gettod)(int *year, int *mon, int *day, int *hour,
 			   int *min, int *sec);
-extern int (*mach_hwclk)(int, struct hwclk_time*);
 extern int (*mach_set_clock_mmss)(unsigned long);
+
+/* machine dependent power off functions */
 extern void (*mach_reset)( void );
 extern void (*mach_halt)( void );
 extern void (*mach_power_off)( void );
-extern unsigned long (*mach_hd_init) (unsigned long, unsigned long);
-extern void (*mach_hd_setup)(char *, int *);
-extern long mach_max_dma_address;
-extern void (*mach_floppy_eject)(void);
-extern void (*mach_heartbeat) (int);
-extern void (*mach_l2_flush) (int);
-extern int mach_sysrq_key;
-extern int mach_sysrq_shift_state;
-extern int mach_sysrq_shift_mask;
-extern char *mach_sysrq_xlate;
 
 extern void config_BSP(char *command, int len);
 extern void (*mach_tick)(void);

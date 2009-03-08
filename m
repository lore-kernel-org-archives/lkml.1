Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbZCHHyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbZCHHyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 03:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZCHHyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 03:54:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:31391 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZCHHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 03:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P1yGL54Dvjn+aZ9UwKpnQLZnwQ1viGJYMHjLtPwMAgb2SBD5FDzgSAm2Fl+SWkuJnA
         5ONt8xrWbmft6A8JbzxM+RW7YR3EoTSYKVYwzM7wjtCtsyYG2EFFn7leub57JmVi9ytn
         yvR1L/RWf99WcH635Y2dNu9et++bKQeldOy5Q=
Date: Sun, 8 Mar 2009 15:54:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [trivial Patch] uml: remove useless comments
Message-ID: <20090308075413.GC30016@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These comments are useless now, remove them.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/drivers/pcap_user.h b/arch/um/drivers/pcap_user.h
index 96b80b5..d8ba615 100644
--- a/arch/um/drivers/pcap_user.h
+++ b/arch/um/drivers/pcap_user.h
@@ -19,13 +19,3 @@ extern const struct net_user_info pcap_user_info;
 
 extern int pcap_user_read(int fd, void *buf, int len, struct pcap_data *pri);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/drivers/port.h b/arch/um/drivers/port.h
index 9117609..372a80c 100644
--- a/arch/um/drivers/port.h
+++ b/arch/um/drivers/port.h
@@ -18,13 +18,3 @@ extern void port_remove_dev(void *d);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/drivers/ssl.h b/arch/um/drivers/ssl.h
index 98412aa..314d177 100644
--- a/arch/um/drivers/ssl.h
+++ b/arch/um/drivers/ssl.h
@@ -11,13 +11,3 @@ extern void ssl_receive_char(int line, char ch);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/drivers/stdio_console.h b/arch/um/drivers/stdio_console.h
index 505a3d5..6d8275f 100644
--- a/arch/um/drivers/stdio_console.h
+++ b/arch/um/drivers/stdio_console.h
@@ -9,13 +9,3 @@
 extern void save_console_flags(void);
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/drivers/xterm.h b/arch/um/drivers/xterm.h
index f33a6e7..56b9c4a 100644
--- a/arch/um/drivers/xterm.h
+++ b/arch/um/drivers/xterm.h
@@ -10,13 +10,3 @@ extern int xterm_fd(int socket, int *pid_out);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/asm/irq_vectors.h b/arch/um/include/asm/irq_vectors.h
index 62ddba6..272a81e 100644
--- a/arch/um/include/asm/irq_vectors.h
+++ b/arch/um/include/asm/irq_vectors.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index 2cf35c2..cf259de 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -10,13 +10,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/asm/pda.h b/arch/um/include/asm/pda.h
index 0d8bf33..ddcd774 100644
--- a/arch/um/include/asm/pda.h
+++ b/arch/um/include/asm/pda.h
@@ -19,13 +19,3 @@ extern struct foo me;
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/asm/pgalloc.h b/arch/um/include/asm/pgalloc.h
index 9062a6e..7189843 100644
--- a/arch/um/include/asm/pgalloc.h
+++ b/arch/um/include/asm/pgalloc.h
@@ -60,13 +60,3 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 0446f45..084de4a 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -134,13 +134,3 @@ static inline pmd_t pfn_pmd(pfn_t page_nr, pgprot_t pgprot)
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/shared/frame_kern.h b/arch/um/include/shared/frame_kern.h
index ce9514f..7607849 100644
--- a/arch/um/include/shared/frame_kern.h
+++ b/arch/um/include/shared/frame_kern.h
@@ -20,13 +20,3 @@ extern int setup_signal_stack_si(unsigned long stack_top, int sig,
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/shared/initrd.h b/arch/um/include/shared/initrd.h
index 439b9a8..22673bc 100644
--- a/arch/um/include/shared/initrd.h
+++ b/arch/um/include/shared/initrd.h
@@ -10,13 +10,3 @@ extern int load_initrd(char *filename, void *buf, int size);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/shared/irq_kern.h b/arch/um/include/shared/irq_kern.h
index fba3895..b05d22f 100644
--- a/arch/um/include/shared/irq_kern.h
+++ b/arch/um/include/shared/irq_kern.h
@@ -16,13 +16,3 @@ extern int um_request_irq(unsigned int irq, int fd, int type,
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/shared/mem_kern.h b/arch/um/include/shared/mem_kern.h
index cb7e196..69be0fd 100644
--- a/arch/um/include/shared/mem_kern.h
+++ b/arch/um/include/shared/mem_kern.h
@@ -18,13 +18,3 @@ extern void register_remapper(struct remapper *info);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/include/shared/ubd_user.h b/arch/um/include/shared/ubd_user.h
index bb66517..3845051 100644
--- a/arch/um/include/shared/ubd_user.h
+++ b/arch/um/include/shared/ubd_user.h
@@ -14,13 +14,3 @@ extern int kernel_fd;
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/kernel/config.c.in b/arch/um/kernel/config.c.in
index c062cbf..f1b2b7d 100644
--- a/arch/um/kernel/config.c.in
+++ b/arch/um/kernel/config.c.in
@@ -20,13 +20,3 @@ __uml_setup("--showconfig", print_config,
 "    Prints the config file that this UML binary was generated from.\n\n"
 );
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-i386/asm/archparam.h b/arch/um/sys-i386/asm/archparam.h
index 93fd723..2a18a88 100644
--- a/arch/um/sys-i386/asm/archparam.h
+++ b/arch/um/sys-i386/asm/archparam.h
@@ -14,13 +14,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-i386/shared/sysdep/checksum.h b/arch/um/sys-i386/shared/sysdep/checksum.h
index 0cb4645..ed47445 100644
--- a/arch/um/sys-i386/shared/sysdep/checksum.h
+++ b/arch/um/sys-i386/shared/sysdep/checksum.h
@@ -199,13 +199,3 @@ static __inline__ __wsum csum_and_copy_to_user(const void *src,
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ia64/sysdep/ptrace.h b/arch/um/sys-ia64/sysdep/ptrace.h
index 42dd8fb..0f0f4e6 100644
--- a/arch/um/sys-ia64/sysdep/ptrace.h
+++ b/arch/um/sys-ia64/sysdep/ptrace.h
@@ -14,13 +14,3 @@ struct sys_pt_regs {
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ia64/sysdep/sigcontext.h b/arch/um/sys-ia64/sysdep/sigcontext.h
index f15fb25..76b4316 100644
--- a/arch/um/sys-ia64/sysdep/sigcontext.h
+++ b/arch/um/sys-ia64/sysdep/sigcontext.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ia64/sysdep/syscalls.h b/arch/um/sys-ia64/sysdep/syscalls.h
index 4a1f46e..5f6700c 100644
--- a/arch/um/sys-ia64/sysdep/syscalls.h
+++ b/arch/um/sys-ia64/sysdep/syscalls.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/miscthings.c b/arch/um/sys-ppc/miscthings.c
index 373061c..1c11aed 100644
--- a/arch/um/sys-ppc/miscthings.c
+++ b/arch/um/sys-ppc/miscthings.c
@@ -40,14 +40,3 @@ void shove_aux_table(unsigned long sp)
 }
 /* END stuff taken from arch/ppc/kernel/process.c */
 
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/ptrace.c b/arch/um/sys-ppc/ptrace.c
index 8e71b47..66ef155 100644
--- a/arch/um/sys-ppc/ptrace.c
+++ b/arch/um/sys-ppc/ptrace.c
@@ -56,13 +56,3 @@ int peek_user(struct task_struct *child, long addr, long data)
 	return put_user(tmp, (unsigned long *) data);
 }
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/ptrace_user.c b/arch/um/sys-ppc/ptrace_user.c
index ff0b9c0..224d240 100644
--- a/arch/um/sys-ppc/ptrace_user.c
+++ b/arch/um/sys-ppc/ptrace_user.c
@@ -27,13 +27,3 @@ int ptrace_setregs(long pid, unsigned long *regs_in)
     }
     return 0;
 }
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/shared/sysdep/ptrace.h b/arch/um/sys-ppc/shared/sysdep/ptrace.h
index df2397d..0e3230e 100644
--- a/arch/um/sys-ppc/shared/sysdep/ptrace.h
+++ b/arch/um/sys-ppc/shared/sysdep/ptrace.h
@@ -91,13 +91,3 @@ extern void shove_aux_table(unsigned long sp);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/shared/sysdep/sigcontext.h b/arch/um/sys-ppc/shared/sysdep/sigcontext.h
index f20d965..b7286f0 100644
--- a/arch/um/sys-ppc/shared/sysdep/sigcontext.h
+++ b/arch/um/sys-ppc/shared/sysdep/sigcontext.h
@@ -50,13 +50,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/shared/sysdep/syscalls.h b/arch/um/sys-ppc/shared/sysdep/syscalls.h
index 679df35..1ff8155 100644
--- a/arch/um/sys-ppc/shared/sysdep/syscalls.h
+++ b/arch/um/sys-ppc/shared/sysdep/syscalls.h
@@ -41,13 +41,3 @@ int old_mmap(unsigned long addr, unsigned long len,
 
 #define LAST_ARCH_SYSCALL __NR_fadvise64
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-ppc/sigcontext.c b/arch/um/sys-ppc/sigcontext.c
index 4bdc15c..40694d0 100644
--- a/arch/um/sys-ppc/sigcontext.c
+++ b/arch/um/sys-ppc/sigcontext.c
@@ -2,13 +2,3 @@
 #include "asm/sigcontext.h"
 #include "sysdep/ptrace.h"
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-x86_64/asm/archparam.h b/arch/um/sys-x86_64/asm/archparam.h
index 270ed95..6c08366 100644
--- a/arch/um/sys-x86_64/asm/archparam.h
+++ b/arch/um/sys-x86_64/asm/archparam.h
@@ -14,13 +14,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-x86_64/asm/module.h b/arch/um/sys-x86_64/asm/module.h
index 35b5491..8eb79c2 100644
--- a/arch/um/sys-x86_64/asm/module.h
+++ b/arch/um/sys-x86_64/asm/module.h
@@ -18,13 +18,3 @@ struct mod_arch_specific
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff --git a/arch/um/sys-x86_64/mem.c b/arch/um/sys-x86_64/mem.c
index 3f59a0a..3f8df8a 100644
--- a/arch/um/sys-x86_64/mem.c
+++ b/arch/um/sys-x86_64/mem.c
@@ -14,12 +14,3 @@ unsigned long vm_data_default_flags = __VM_DATA_DEFAULT_FLAGS;
 unsigned long vm_data_default_flags32 = __VM_DATA_DEFAULT_FLAGS;
 unsigned long vm_force_exec32 = PROT_EXEC;
 
-/* Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */

 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0BGTpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:45:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:53455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960Ab0BGTo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:44:58 -0500
Date: Sun, 7 Feb 2010 19:42:33 GMT
From: tip-bot for Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       elendil@planet.nl, tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       elendil@planet.nl, tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1265478443-31072-10-git-send-email-elendil@planet.nl>
References: <1265478443-31072-10-git-send-email-elendil@planet.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove trailing spaces in messages
Message-ID: <tip-3235dc3f22378f35ce77eba0d0f62db2d9c4844e@git.kernel.org>
Git-Commit-ID: 3235dc3f22378f35ce77eba0d0f62db2d9c4844e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 07 Feb 2010 19:42:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3235dc3f22378f35ce77eba0d0f62db2d9c4844e
Gitweb:     http://git.kernel.org/tip/3235dc3f22378f35ce77eba0d0f62db2d9c4844e
Author:     Frans Pop <elendil@planet.nl>
AuthorDate: Sat, 6 Feb 2010 18:47:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Feb 2010 17:47:51 +0100

x86: Remove trailing spaces in messages

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org
LKML-Reference: <1265478443-31072-10-git-send-email-elendil@planet.nl>
[ Left out the KVM bits. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/mkcpustr.c          |    2 +-
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/apic/io_apic.c    |    2 +-
 arch/x86/kernel/apic/numaq_32.c   |    2 +-
 arch/x86/kernel/apm_32.c          |    4 ++--
 arch/x86/kernel/efi.c             |    2 +-
 arch/x86/kernel/microcode_intel.c |    2 +-
 arch/x86/kernel/uv_sysfs.c        |    6 +++---
 arch/x86/tools/test_get_len.c     |    4 ++--
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 8ef60f2..919257f 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -22,7 +22,7 @@ int main(void)
 	int i, j;
 	const char *str;
 
-	printf("static const char x86_cap_strs[] = \n");
+	printf("static const char x86_cap_strs[] =\n");
 
 	for (i = 0; i < NCAPINTS; i++) {
 		for (j = 0; j < 32; j++) {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e80f291..71c4443 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -587,7 +587,7 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
 		res = (((u64)(*deltatsc)) * pm_100ms);
 		do_div(res, deltapm);
 		apic_printk(APIC_VERBOSE, "TSC delta adjusted to "
-					  "PM-Timer: %lu (%ld) \n",
+					  "PM-Timer: %lu (%ld)\n",
 					(unsigned long)res, *deltatsc);
 		*deltatsc = (long)res;
 	}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53243ca..6bdd2c7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1647,7 +1647,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
 	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			  " Stat Dmod Deli Vect:   \n");
+			  " Stat Dmod Deli Vect:\n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 98c4665..47dd856 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -225,7 +225,7 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 
 	mpc_record = 0;
 	printk(KERN_INFO
-		"Found an OEM MPC table at %8p - parsing it ... \n", oemtable);
+		"Found an OEM MPC table at %8p - parsing it...\n", oemtable);
 
 	if (memcmp(oemtable->signature, MPC_OEM_SIGNATURE, 4)) {
 		printk(KERN_WARNING
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index b5b6b23..031aa88 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1992,8 +1992,8 @@ static int __init apm_is_horked_d850md(const struct dmi_system_id *d)
 		apm_info.disabled = 1;
 		printk(KERN_INFO "%s machine detected. "
 		       "Disabling APM.\n", d->ident);
-		printk(KERN_INFO "This bug is fixed in bios P15 which is available for \n");
-		printk(KERN_INFO "download from support.intel.com \n");
+		printk(KERN_INFO "This bug is fixed in bios P15 which is available for\n");
+		printk(KERN_INFO "download from support.intel.com\n");
 	}
 	return 0;
 }
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index cdcfb12..c2fa9b8 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -362,7 +362,7 @@ void __init efi_init(void)
 		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
 	early_iounmap(tmp, 2);
 
-	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
+	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index ebd193e..85a343e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -328,7 +328,7 @@ static int apply_microcode(int cpu)
 		       cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
-	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x \n",
+	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
 		cpu_num, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/kernel/uv_sysfs.c
index 36afb98..309c70f 100644
--- a/arch/x86/kernel/uv_sysfs.c
+++ b/arch/x86/kernel/uv_sysfs.c
@@ -54,19 +54,19 @@ static int __init sgi_uv_sysfs_init(void)
 	if (!sgi_uv_kobj)
 		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
 	if (!sgi_uv_kobj) {
-		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed \n");
+		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed\n");
 		return -EINVAL;
 	}
 
 	ret = sysfs_create_file(sgi_uv_kobj, &partition_id_attr.attr);
 	if (ret) {
-		printk(KERN_WARNING "sysfs_create_file partition_id failed \n");
+		printk(KERN_WARNING "sysfs_create_file partition_id failed\n");
 		return ret;
 	}
 
 	ret = sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);
 	if (ret) {
-		printk(KERN_WARNING "sysfs_create_file coherence_id failed \n");
+		printk(KERN_WARNING "sysfs_create_file coherence_id failed\n");
 		return ret;
 	}
 
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index bee8d6a..13403fc 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -43,7 +43,7 @@ static int x86_64;
 static void usage(void)
 {
 	fprintf(stderr, "Usage: objdump -d a.out | awk -f distill.awk |"
-		" %s [-y|-n] [-v] \n", prog);
+		" %s [-y|-n] [-v]\n", prog);
 	fprintf(stderr, "\t-y	64bit mode\n");
 	fprintf(stderr, "\t-n	32bit mode\n");
 	fprintf(stderr, "\t-v	verbose mode\n");
@@ -69,7 +69,7 @@ static void dump_field(FILE *fp, const char *name, const char *indent,
 
 static void dump_insn(FILE *fp, struct insn *insn)
 {
-	fprintf(fp, "Instruction = { \n");
+	fprintf(fp, "Instruction = {\n");
 	dump_field(fp, "prefixes", "\t",	&insn->prefixes);
 	dump_field(fp, "rex_prefix", "\t",	&insn->rex_prefix);
 	dump_field(fp, "vex_prefix", "\t",	&insn->vex_prefix);

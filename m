Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab0BFRs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:48:56 -0500
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:62929 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932405Ab0BFRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:28 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/16] x86: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:17 +0100
Message-Id: <1265478443-31072-10-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0340 (UTC) FILETIME=[71E4EC40:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kvm/vmx.c also:
- join two related error messages into a single line
- remove an unnecessary period

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: x86@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
---

Please review the following with extra attention:
- arch/x86/boot/mkcpustr.c
- arch/x86/tools/test_get_len.c
---
 arch/x86/boot/mkcpustr.c          |    2 +-
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/apic/io_apic.c    |    2 +-
 arch/x86/kernel/apic/numaq_32.c   |    2 +-
 arch/x86/kernel/apm_32.c          |    4 ++--
 arch/x86/kernel/efi.c             |    2 +-
 arch/x86/kernel/microcode_intel.c |    2 +-
 arch/x86/kernel/uv_sysfs.c        |    6 +++---
 arch/x86/kvm/vmx.c                |    5 ++---
 arch/x86/tools/test_get_len.c     |    4 ++--
 10 files changed, 15 insertions(+), 16 deletions(-)

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
index 3987e44..a85f216 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -581,7 +581,7 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
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
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d4918d6..2e3377d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1570,7 +1570,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	if ((guest_tr_ar & AR_TYPE_MASK) != AR_TYPE_BUSY_64_TSS) {
-		printk(KERN_DEBUG "%s: tss fixup for long mode. \n",
+		printk(KERN_DEBUG "%s: tss fixup for long mode\n",
 		       __func__);
 		vmcs_write32(GUEST_TR_AR_BYTES,
 			     (guest_tr_ar & ~AR_TYPE_MASK)
@@ -3343,8 +3343,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
-	printk(KERN_ERR "EPT: Misconfiguration.\n");
-	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
+	printk(KERN_ERR "EPT: Misconfiguration; GPA: 0x%llx\n", gpa);
 
 	nr_sptes = kvm_mmu_get_spte_hierarchy(vcpu, gpa, sptes);
 
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
-- 
1.6.6.1


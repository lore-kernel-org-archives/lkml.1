Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbXFTStZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbXFTStZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbXFTSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:43:13 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:45194 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763127AbXFTSnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:43:10 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:54 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 7/8] 2.6.22-rc3 perfmon2 : Renaming *_k8_* symbols to
 *_amd64_*
Message-ID: <20070620184154.GH5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:54.0738 (UTC)
 FILETIME=[AC9F6120:01C7B36A]
X-WSS-ID: 6A67AAA41S4957843-05-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-007.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames *_k8_* symbols to *_amd64_*.

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -36,7 +36,7 @@ static int force_nmi;
 MODULE_PARM_DESC(force_nmi, "bool: force use of NMI for PMU interrupt");
 module_param(force_nmi, bool, 0600);
 
-static struct pfm_arch_pmu_info pfm_k8_pmu_info = {
+static struct pfm_arch_pmu_info pfm_amd64_pmu_info = {
 	.pmc_addrs = {
 /* pmc0  */	{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
 /* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
@@ -96,7 +96,7 @@ static struct pfm_arch_pmu_info pfm_k8_p
 #define PFM_AMD64_IBSOPCTL_NO64		PFM_AMD64_IBSOPEN
 #define PFM_AMD64_IBSOPCTL_RSVD		(~((1ULL<<16)-1))
 
-static struct pfm_reg_desc pfm_k8_pmc_desc[]={
+static struct pfm_reg_desc pfm_amd64_pmc_desc[]={
 /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
 /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
 /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
@@ -104,9 +104,9 @@ static struct pfm_reg_desc pfm_k8_pmc_de
 /* pmc4  */ PMC_D(PFM_REG_I, "IBSFETCHCTL", PFM_AMD64_IBSFETCHCTL_VAL, PFM_AMD64_IBSFETCHCTL_RSVD, PFM_AMD64_IBSFETCHCTL_NO64, MSR_AMD64_IBSFETCHCTL),
 /* pmc5  */ PMC_D(PFM_REG_I, "IBSOPCTL", PFM_AMD64_IBSOPCTL_VAL, PFM_AMD64_IBSOPCTL_RSVD, PFM_AMD64_IBSOPCTL_NO64, MSR_AMD64_IBSOPCTL),
 };
-#define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
+#define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_amd64_pmc_desc)
 
-static struct pfm_reg_desc pfm_k8_pmd_desc[] = {
+static struct pfm_reg_desc pfm_amd64_pmd_desc[] = {
 /* pmd0  */ PMD_D(PFM_REG_C,   "PERFCTR0",	MSR_K7_PERFCTR0),
 /* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
 /* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
@@ -124,12 +124,12 @@ static struct pfm_reg_desc pfm_k8_pmd_de
 /* pmd14 */ PMD_D(PFM_REG_IRO, "IBSDCLINAD",	MSR_AMD64_IBSDCLINAD),
 /* pmd15 */ PMD_D(PFM_REG_IRO, "IBSDCPHYSAD",	MSR_AMD64_IBSDCPHYSAD),
 };
-#define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
+#define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_amd64_pmd_desc)
 
 static struct pfm_context **pfm_nb_sys_owners;
 static struct pfm_context *pfm_nb_task_owner;
 
-static struct pfm_pmu_config pfm_k8_pmu_conf;
+static struct pfm_pmu_config pfm_amd64_pmu_conf;
 
 /*
  * There can only one user per socket for the Northbridge (NB) events
@@ -148,7 +148,7 @@ static struct pfm_pmu_config pfm_k8_pmu_
  * 	0  : successfully acquire NB access
  * 	< 0:  errno, failed to acquire NB access
  */
-static int pfm_k8_acquire_nb(struct pfm_context *ctx)
+static int pfm_amd64_acquire_nb(struct pfm_context *ctx)
 {
 	struct pfm_context **entry, *old;
 	int proc_id;
@@ -186,7 +186,7 @@ static int pfm_k8_acquire_nb(struct pfm_
  *
  * context is locked, interrupts are masked
  */
-static int pfm_k8_pmc_write_check(struct pfm_context *ctx,
+static int pfm_amd64_pmc_write_check(struct pfm_context *ctx,
 			     struct pfm_event_set *set,
 			     struct pfarg_pmc *req)
 {
@@ -204,14 +204,14 @@ static int pfm_k8_pmc_write_check(struct
 	if (event < 0xee)
 		return 0;
 
-	return pfm_k8_acquire_nb(ctx);
+	return pfm_amd64_acquire_nb(ctx);
 }
 
 /*
  * invoked on pfm_load_context().
  * context is locked, interrupts are masked
  */
-static int pfm_k8_load_context(struct pfm_context *ctx)
+static int pfm_amd64_load_context(struct pfm_context *ctx)
 {
 	struct pfm_event_set *set;
 	unsigned int i, n;
@@ -231,13 +231,13 @@ static int pfm_k8_load_context(struct pf
 	}
 	return 0;
 found:
-	return pfm_k8_acquire_nb(ctx);
+	return pfm_amd64_acquire_nb(ctx);
 }
 
 /*
  * invoked on pfm_unload_context()
  */
-static int pfm_k8_unload_context(struct pfm_context *ctx)
+static int pfm_amd64_unload_context(struct pfm_context *ctx)
 {
 	struct pfm_context **entry, *old;
 	int proc_id;
@@ -269,7 +269,7 @@ static int pfm_k8_unload_context(struct 
 /*
  * detect if we need to active NorthBridge event access control
  */
-static int pfm_k8_setup_nb_event_control(void)
+static int pfm_amd64_setup_nb_event_control(void)
 {
 	unsigned int c, n = 0;
 	unsigned int max_phys = 0;
@@ -302,25 +302,25 @@ static int pfm_k8_setup_nb_event_control
 	 * activate write-checker for PMC registers
 	 */
 	for(c=0; c < PFM_AMD_NUM_PMCS; c++) {
-		pfm_k8_pmc_desc[c].type |= PFM_REG_WC;
+		pfm_amd64_pmc_desc[c].type |= PFM_REG_WC;
 	}
 
-	pfm_k8_pmu_conf.load_context = pfm_k8_load_context;
-	pfm_k8_pmu_conf.unload_context = pfm_k8_unload_context;
-	pfm_k8_pmu_conf.pmc_write_check = pfm_k8_pmc_write_check;
+	pfm_amd64_pmu_conf.load_context = pfm_amd64_load_context;
+	pfm_amd64_pmu_conf.unload_context = pfm_amd64_unload_context;
+	pfm_amd64_pmu_conf.pmc_write_check = pfm_amd64_pmc_write_check;
 
 	PFM_INFO("NorthBridge event access control enabled");
 
 	return 0;
 }
 
-static int pfm_k8_detect_nmi(void)
+static int pfm_amd64_detect_nmi(void)
 {
 	unsigned int i;
 
 	if (nmi_watchdog != NMI_LOCAL_APIC) {
 		if (force_nmi)
-			pfm_k8_pmu_info.flags |= PFM_X86_FL_USE_NMI;
+			pfm_amd64_pmu_info.flags |= PFM_X86_FL_USE_NMI;
 		return 0;
 	}
 
@@ -330,25 +330,25 @@ static int pfm_k8_detect_nmi(void)
 	 */
 	for (i=0; i < PFM_AMD_NUM_PMDS; i++) {
 		/* skip IBS registers */
-		if (pfm_k8_pmu_info.pmc_addrs[i].reg_type & PFM_REGT_IBS)
+		if (pfm_amd64_pmu_info.pmc_addrs[i].reg_type & PFM_REGT_IBS)
 			continue;
-		if (avail_to_resrv_perfctr_nmi(pfm_k8_pmd_desc[i].hw_addr))
+		if (avail_to_resrv_perfctr_nmi(pfm_amd64_pmd_desc[i].hw_addr))
 			continue;
 
 		PFM_INFO("NMI watchdog using %s/%s, disabling for perfmon",
-				pfm_k8_pmc_desc[i].desc,
-				pfm_k8_pmd_desc[i].desc);
+				pfm_amd64_pmc_desc[i].desc,
+				pfm_amd64_pmd_desc[i].desc);
 
-		pfm_k8_pmc_desc[i].type = PFM_REG_NA;
-		pfm_k8_pmd_desc[i].type = PFM_REG_NA;
-		pfm_k8_pmu_info.pmc_addrs[i].reg_type = PFM_REGT_NA;
-		pfm_k8_pmu_info.pmd_addrs[i].reg_type = PFM_REGT_NA;
+		pfm_amd64_pmc_desc[i].type = PFM_REG_NA;
+		pfm_amd64_pmd_desc[i].type = PFM_REG_NA;
+		pfm_amd64_pmu_info.pmc_addrs[i].reg_type = PFM_REGT_NA;
+		pfm_amd64_pmu_info.pmd_addrs[i].reg_type = PFM_REGT_NA;
 	}
-	pfm_k8_pmu_info.flags |= PFM_X86_FL_USE_NMI;
+	pfm_amd64_pmu_info.flags |= PFM_X86_FL_USE_NMI;
 	return 0;
 }
 
-static int pfm_k8_probe_pmu(void)
+static int pfm_amd64_probe_pmu(void)
 {
 	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD) {
 		PFM_INFO("not an AMD processor");
@@ -372,17 +372,17 @@ static int pfm_k8_probe_pmu(void)
 		PFM_INFO("no local APIC, unsupported");
 		return -1;
 	}
-	if (pfm_k8_detect_nmi()) {
+	if (pfm_amd64_detect_nmi()) {
 		PFM_INFO("NMI detection failed");
 		return -1;
 	}
 	if (current_cpu_data.x86_max_cores > 1)
-		pfm_k8_setup_nb_event_control();
+		pfm_amd64_setup_nb_event_control();
 
 	PFM_INFO("Using AMD64 PMU");
-	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS)
+	if (pfm_amd64_pmu_info.flags & PFM_X86_FL_IBS)
 		PFM_INFO("IBS is supported by processor");
-	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS_EXT)
+	if (pfm_amd64_pmu_info.flags & PFM_X86_FL_IBS_EXT)
 		PFM_INFO("IBS extended registers are supported by processor");
 
 	return 0;
@@ -449,35 +449,35 @@ static void pfm_amd64_setup_pmu(struct p
 	}
 }
 
-static struct pfm_pmu_config pfm_k8_pmu_conf = {
+static struct pfm_pmu_config pfm_amd64_pmu_conf = {
 	.pmu_name = "AMD64",
 	.counter_width = 47,
-	.pmd_desc = pfm_k8_pmd_desc,
-	.pmc_desc = pfm_k8_pmc_desc,
+	.pmd_desc = pfm_amd64_pmd_desc,
+	.pmc_desc = pfm_amd64_pmc_desc,
 	.num_pmc_entries = PFM_AMD_NUM_PMCS,
 	.num_pmd_entries = PFM_AMD_NUM_PMDS,
-	.probe_pmu = pfm_k8_probe_pmu,
+	.probe_pmu = pfm_amd64_probe_pmu,
 	.version = "1.2",
-	.arch_info = &pfm_k8_pmu_info,
+	.arch_info = &pfm_amd64_pmu_info,
 	.flags = PFM_PMU_BUILTIN_FLAG,
 	.owner = THIS_MODULE,
 	.pmd_sread = pfm_pmd_sread,
 	.pmd_swrite = pfm_pmd_swrite,
 };
 	
-static int __init pfm_k8_pmu_init_module(void)
+static int __init pfm_amd64_pmu_init_module(void)
 {
-	pfm_amd64_setup_pmu(&pfm_k8_pmu_conf);
-	return pfm_pmu_register(&pfm_k8_pmu_conf);
+	pfm_amd64_setup_pmu(&pfm_amd64_pmu_conf);
+	return pfm_pmu_register(&pfm_amd64_pmu_conf);
 }
 
-static void __exit pfm_k8_pmu_cleanup_module(void)
+static void __exit pfm_amd64_pmu_cleanup_module(void)
 {
 	if (pfm_nb_sys_owners)
 		vfree(pfm_nb_sys_owners);
 
-	pfm_pmu_unregister(&pfm_k8_pmu_conf);
+	pfm_pmu_unregister(&pfm_amd64_pmu_conf);
 }
 
-module_init(pfm_k8_pmu_init_module);
-module_exit(pfm_k8_pmu_cleanup_module);
+module_init(pfm_amd64_pmu_init_module);
+module_exit(pfm_amd64_pmu_cleanup_module);

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




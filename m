Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbYCGVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbYCGVGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932749AbYCGVFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:05:31 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:7175 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbYCGVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XKoyGClYOjyl/LkPVsUPOB5Foh/5MCEmXJ54b1mZzpznmSxK5S/IV5iL8wKblOUnrlOfVEoo1bZVhNCnzVykwB88lcW17GKZzQf2/kka7o+RbMo9aTLd1hDBJdFVcostVuvStiOZClFvsZq6Uv4s12IINgMkNRpc2zeC3xIeu/E=
Message-ID: <7c86c4470803071305l243f1eb4q2d2a75ee0f58ff@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:05:27 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perfmon x86 infra(take 2): add cpu_has_arch_perfmon
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ak@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds cpu_has_arch_perfmon to test presence of architectural perfmon on
Intel x86 processor

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -181,6 +181,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_clflush                boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts            boot_cpu_has(X86_FEATURE_BTS)
 #define cpu_has_gbpages                boot_cpu_has(X86_FEATURE_GBPAGES)
+#define cpu_has_arch_perfmon   boot_cpu_has(X86_FEATURE_ARCH_PERFMON)

 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg                1

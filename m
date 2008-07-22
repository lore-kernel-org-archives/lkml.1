Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYGVUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYGVUVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYGVUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:21:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:60774 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYGVUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=F1UTd3i5q2MtFb5lFrGAAP9E4O6I8p2c/wdKaGAD6n9LpX4t+X3auIYO9LI3wIehDe
         9grS/PWIkkzWmIcRI6TPphF43Eu7YYsjTcovwzq+o7wCioZ+ADd102IbJ9x4sbxRHReP
         +zsGrC6n317PRmOAN2TCpTgFqXgUcniOmulOk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: move declaring x2apic_extra_bits
Date: Tue, 22 Jul 2008 13:20:22 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com>
In-Reply-To: <200807212208.22116.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221320.22729.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it is for uv only

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/genx2apic_phys.c |    2 --
 arch/x86/kernel/genx2apic_uv_x.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6/arch/x86/kernel/genx2apic_phys.c
@@ -10,8 +10,6 @@
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
-DEFINE_PER_CPU(int, x2apic_extra_bits);
-
 static int x2apic_phys;
 
 static int set_x2apic_phys_mode(char *arg)
Index: linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
@@ -27,6 +27,8 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
 
+DEFINE_PER_CPU(int, x2apic_extra_bits);
+
 static enum uv_system_type uv_system_type;
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0BMBk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:40:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:10815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab0BMBku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="540400425"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:49 -0800
Subject: [PATCH 3/8] x86/mrst: add dummy legacy pic to platform setup
Thread-Topic: [PATCH 3/8] x86/mrst: add dummy legacy pic to platform setup
Thread-Index: AcqsTZHjbZbh8H2sR2ykO7o0TWehHg==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D09@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 91c30c1822db4dfa3f4644fbc284e5322ff59d70 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 12 Feb 2010 02:29:11 -0800
Subject: [PATCH 3/8] x86/mrst: add dummy legacy pic to platform setup

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/mrst.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 3b7078a..bdf9b17 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -12,6 +12,9 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
+#include <asm/mrst.h>
+#include <asm/io.h>
+#include <asm/i8259.h>
 
 /*
  * Moorestown specific x86_init function overrides and early setup
@@ -21,4 +24,6 @@ void __init x86_mrst_early_setup(void)
 {
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.resources.reserve_resources = x86_init_noop;
+
+	legacy_pic = &null_legacy_pic;
 }
-- 
1.6.5.3


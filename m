Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbZCRVy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbZCRVy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZCRVnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:51 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758244AbZCRVns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:48 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 46/57] microblaze_v7: headers simple files - empty or redirect to asm-generic
Date: Wed, 18 Mar 2009 21:31:13 +0100
Message-Id: <1e1dc8ccd5abc4e51272f52465c6b9e5f847f947.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <5f12a0cd5bd492df05689715eb73b03b2a07f5d4.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
 <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
 <1ca9913fc2b9ec220fdb9909f7929abfc38e41b1.1237407249.git.monstr@monstr.eu>
 <4a7e63a56ea0490013724ffddb9f824caafdcbc6.1237407249.git.monstr@monstr.eu>
 <6d67a197ab9f953b93ef151d9a4a198ba0730ef5.1237407249.git.monstr@monstr.eu>
 <d6fb0da1d4e4e5ac85ddca0ee61b81d3da8e95c5.1237407249.git.monstr@monstr.eu>
 <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu>
 <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu>
 <5f12a0cd5bd492df05689715eb73b03b2a07f5d4.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/cputime.h           |    1 +
 arch/microblaze/include/asm/div64.h             |    1 +
 arch/microblaze/include/asm/emergency-restart.h |    1 +
 arch/microblaze/include/asm/errno.h             |    1 +
 arch/microblaze/include/asm/futex.h             |    1 +
 arch/microblaze/include/asm/gpio.h              |   56 +++++++++++++++++++++++
 arch/microblaze/include/asm/kdebug.h            |    1 +
 arch/microblaze/include/asm/local.h             |    1 +
 arch/microblaze/include/asm/mutex.h             |    1 +
 arch/microblaze/include/asm/percpu.h            |    1 +
 arch/microblaze/include/asm/resource.h          |    1 +
 arch/microblaze/include/asm/serial.h            |   14 ++++++
 12 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/auxvec.h
 create mode 100644 arch/microblaze/include/asm/cputable.h
 create mode 100644 arch/microblaze/include/asm/cputime.h
 create mode 100644 arch/microblaze/include/asm/div64.h
 create mode 100644 arch/microblaze/include/asm/emergency-restart.h
 create mode 100644 arch/microblaze/include/asm/errno.h
 create mode 100644 arch/microblaze/include/asm/futex.h
 create mode 100644 arch/microblaze/include/asm/gpio.h
 create mode 100644 arch/microblaze/include/asm/kdebug.h
 create mode 100644 arch/microblaze/include/asm/local.h
 create mode 100644 arch/microblaze/include/asm/mutex.h
 create mode 100644 arch/microblaze/include/asm/percpu.h
 create mode 100644 arch/microblaze/include/asm/resource.h
 create mode 100644 arch/microblaze/include/asm/serial.h
 create mode 100644 arch/microblaze/include/asm/user.h

diff --git a/arch/microblaze/include/asm/auxvec.h b/arch/microblaze/include/asm/auxvec.h
new file mode 100644
index 0000000..e69de29
diff --git a/arch/microblaze/include/asm/cputable.h b/arch/microblaze/include/asm/cputable.h
new file mode 100644
index 0000000..e69de29
diff --git a/arch/microblaze/include/asm/cputime.h b/arch/microblaze/include/asm/cputime.h
new file mode 100644
index 0000000..6d68ad7
--- /dev/null
+++ b/arch/microblaze/include/asm/cputime.h
@@ -0,0 +1 @@
+#include <asm-generic/cputime.h>
diff --git a/arch/microblaze/include/asm/div64.h b/arch/microblaze/include/asm/div64.h
new file mode 100644
index 0000000..6cd978c
--- /dev/null
+++ b/arch/microblaze/include/asm/div64.h
@@ -0,0 +1 @@
+#include <asm-generic/div64.h>
diff --git a/arch/microblaze/include/asm/emergency-restart.h b/arch/microblaze/include/asm/emergency-restart.h
new file mode 100644
index 0000000..3711bd9
--- /dev/null
+++ b/arch/microblaze/include/asm/emergency-restart.h
@@ -0,0 +1 @@
+#include <asm-generic/emergency-restart.h>
diff --git a/arch/microblaze/include/asm/errno.h b/arch/microblaze/include/asm/errno.h
new file mode 100644
index 0000000..4c82b50
--- /dev/null
+++ b/arch/microblaze/include/asm/errno.h
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
diff --git a/arch/microblaze/include/asm/futex.h b/arch/microblaze/include/asm/futex.h
new file mode 100644
index 0000000..0b74582
--- /dev/null
+++ b/arch/microblaze/include/asm/futex.h
@@ -0,0 +1 @@
+#include <asm-generic/futex.h>
diff --git a/arch/microblaze/include/asm/gpio.h b/arch/microblaze/include/asm/gpio.h
new file mode 100644
index 0000000..ea04632
--- /dev/null
+++ b/arch/microblaze/include/asm/gpio.h
@@ -0,0 +1,56 @@
+/*
+ * Generic GPIO API implementation for PowerPC.
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_POWERPC_GPIO_H
+#define __ASM_POWERPC_GPIO_H
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * We don't (yet) implement inlined/rapid versions for on-chip gpios.
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* __ASM_POWERPC_GPIO_H */
diff --git a/arch/microblaze/include/asm/kdebug.h b/arch/microblaze/include/asm/kdebug.h
new file mode 100644
index 0000000..6ece1b0
--- /dev/null
+++ b/arch/microblaze/include/asm/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff --git a/arch/microblaze/include/asm/local.h b/arch/microblaze/include/asm/local.h
new file mode 100644
index 0000000..c11c530
--- /dev/null
+++ b/arch/microblaze/include/asm/local.h
@@ -0,0 +1 @@
+#include <asm-generic/local.h>
diff --git a/arch/microblaze/include/asm/mutex.h b/arch/microblaze/include/asm/mutex.h
new file mode 100644
index 0000000..ff6101a
--- /dev/null
+++ b/arch/microblaze/include/asm/mutex.h
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff --git a/arch/microblaze/include/asm/percpu.h b/arch/microblaze/include/asm/percpu.h
new file mode 100644
index 0000000..06a959d
--- /dev/null
+++ b/arch/microblaze/include/asm/percpu.h
@@ -0,0 +1 @@
+#include <asm-generic/percpu.h>
diff --git a/arch/microblaze/include/asm/resource.h b/arch/microblaze/include/asm/resource.h
new file mode 100644
index 0000000..04bc4db
--- /dev/null
+++ b/arch/microblaze/include/asm/resource.h
@@ -0,0 +1 @@
+#include <asm-generic/resource.h>
diff --git a/arch/microblaze/include/asm/serial.h b/arch/microblaze/include/asm/serial.h
new file mode 100644
index 0000000..39bfc8c
--- /dev/null
+++ b/arch/microblaze/include/asm/serial.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SERIAL_H
+#define _ASM_MICROBLAZE_SERIAL_H
+
+# define BASE_BAUD (1843200 / 16)
+
+#endif /* _ASM_MICROBLAZE_SERIAL_H */
diff --git a/arch/microblaze/include/asm/user.h b/arch/microblaze/include/asm/user.h
new file mode 100644
index 0000000..e69de29
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZLOBne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZLOBne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZLOBne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:43:34 -0500
Received: from cgp-fe01.mtu.ru ([62.5.255.15]:42126 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844AbZLOBnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:43:33 -0500
From: Pavel Vasilyev <pavel@pavlinux.ru>
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: May be not need MTRR for K8 systems without  AGP
Date: Tue, 15 Dec 2009 04:43:30 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912150443.30405@PAVLINUX->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subj!

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 32a1918..571d8b7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1334,7 +1334,7 @@ config MATH_EMULATION
 config MTRR
        bool
        default y
-       prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
+       prompt "MTRR (Memory Type Range Register) support" if (EMBEDDED || 
(MK8 && AGP))
        ---help---
          On Intel P6 family processors (Pentium Pro, Pentium II and later)
          the Memory Type Range Registers (MTRRs) may be used to control

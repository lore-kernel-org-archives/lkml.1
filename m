Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZAEW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZAEW6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZAEW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:58:43 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:33648 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZAEW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=OQrVw9Ld9U4qxBLERpJyqOGeAY4zPV2uUjhNRnvN2FUZSheHEXVrIWpHSwuljm+UZ/
         8Ns6ARtuCsf1w5bW7D0f9bpuhtpSJkKASqbMpDV4HnxfRZ5bEhGmg1msTiZVr6soCRd6
         vOusKcLYM2Am8vvitbH58AnfeBAXu5IMezvxo=
Date: Tue, 06 Jan 2009 06:58:39 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu
Subject: x86: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090106065718.52C8.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in
  arch/x86/kernel/mpparse.c
  arch/x86/kernel/nmi.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c5c5b8d..76ee713 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -17,7 +17,6 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/acpi.h>

 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 45a09cc..7228979 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,7 +26,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
-#include <linux/nmi.h>

 #include <asm/i8259.h>
 #include <asm/io_apic.h>


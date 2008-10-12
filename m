Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYJLJXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYJLJXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYJLJXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:23:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:30881 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJLJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=cykz2s+gSUQshZZCAEvdnnISg8t5HBRFwShjsWJxNDZTW0GNTrxY9cGxjP9xW1ZfjI
         d4xhnAc4xN9vOziaIVphiVARgAutbryg9dV62k7TtIWE/ok3ujUoXBZF1UanUw0kWIja
         Dt04rxuIer0qJQTzJiJm+3U2oJ3oWvxM1yykA=
Date: Sun, 12 Oct 2008 17:23:31 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: x86: I/O APIC: removed duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081012172152.F6DE.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include <linux/dmar.h> in 
arch/x86/kernel/io_apic_64.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index a1bec29..2b082dc 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -37,7 +37,6 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <linux/bootmem.h>
-#include <linux/dmar.h>

 #include <asm/idle.h>
 #include <asm/io.h>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab0CCJTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:19:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:35494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0CCJTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:19:10 -0500
Date: Wed, 3 Mar 2010 09:18:42 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1267550368-7435-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1267550368-7435-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Remove X86_MRST dependency on PCI_IOAPIC
Message-ID: <tip-d8111cd91abee016d62b401e057fee66ba80be67@git.kernel.org>
Git-Commit-ID: d8111cd91abee016d62b401e057fee66ba80be67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 09:18:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8111cd91abee016d62b401e057fee66ba80be67
Gitweb:     http://git.kernel.org/tip/d8111cd91abee016d62b401e057fee66ba80be67
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Tue, 2 Mar 2010 09:19:28 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Mar 2010 18:15:05 -0800

x86, mrst: Remove X86_MRST dependency on PCI_IOAPIC

PCI_IOAPIC is used for PCI hotplug, Moorestown does not have ACPI PCI
hotplug, as it does not have ACPI.  This unnecessary dependency causes
X86_MRST fail to be selected if ACPI is not selected.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1267550368-7435-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2697fdb..d22686f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -390,7 +390,6 @@ config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
 	depends on PCI_GOANY
-	depends on PCI_IOAPIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC

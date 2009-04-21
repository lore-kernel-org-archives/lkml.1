Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZDUIJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZDUIJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZDUIIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:08:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbZDUIIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:08:05 -0400
Date: Tue, 21 Apr 2009 08:07:22 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, weidong.han@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, suresh.b.siddha@intel.com, weidong.han@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090420200450.694598000@linux-os.sc.intel.com>
References: <20090420200450.694598000@linux-os.sc.intel.com>
Subject: [tip:x86/apic] x86: x2apic, IR: Make config X86_UV dependent on X86_X2APIC
Message-ID: <tip-9d6c26e73bd248c286bb3597aaf788716e8fcceb@git.kernel.org>
Git-Commit-ID: 9d6c26e73bd248c286bb3597aaf788716e8fcceb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:07:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d6c26e73bd248c286bb3597aaf788716e8fcceb
Gitweb:     http://git.kernel.org/tip/9d6c26e73bd248c286bb3597aaf788716e8fcceb
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 20 Apr 2009 13:02:31 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 09:08:27 +0200

x86: x2apic, IR: Make config X86_UV dependent on X86_X2APIC

Instead of selecting X86_X2APIC, make config X86_UV dependent
on X86_X2APIC.

This will eliminate enabling CONFIG_X86_X2APIC with out
enabling CONFIG_INTR_REMAP.

[ Impact: cleanup ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: dwmw2@infradead.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
LKML-Reference: <20090420200450.694598000@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9086e6..58fb7b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -354,7 +354,7 @@ config X86_UV
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
-	select X86_X2APIC
+	depends on X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.

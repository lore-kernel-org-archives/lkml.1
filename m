Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZFGOZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZFGOZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZFGOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:25:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbZFGOZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:25:18 -0400
Date: Sun, 7 Jun 2009 14:24:42 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090607081937.GC4547@lenovo>
References: <20090607081937.GC4547@lenovo>
Subject: [tip:x86/cleanups] x86, nmi: Use predefined numbers instead of hardcoded one
Message-ID: <tip-a4046f8d299e00e9855ae292527c2d66a42670eb@git.kernel.org>
Git-Commit-ID: a4046f8d299e00e9855ae292527c2d66a42670eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 14:24:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4046f8d299e00e9855ae292527c2d66a42670eb
Gitweb:     http://git.kernel.org/tip/a4046f8d299e00e9855ae292527c2d66a42670eb
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 7 Jun 2009 12:19:37 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 16:22:02 +0200

x86, nmi: Use predefined numbers instead of hardcoded one

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090607081937.GC4547@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/nmi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c45a0a5..c972644 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -64,7 +64,7 @@ static inline int nmi_watchdog_active(void)
 	 * but since they are power of two we could use a
 	 * cheaper way --cvg
 	 */
-	return nmi_watchdog & 0x3;
+	return nmi_watchdog & (NMI_LOCAL_APIC | NMI_IO_APIC);
 }
 #endif
 

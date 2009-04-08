Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbZDHNCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbZDHNCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764367AbZDHNBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764999AbZDHNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:01:32 -0400
Date: Wed, 8 Apr 2009 13:01:06 GMT
From: Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403203942.GA20137@sgi.com>
References: <20090403203942.GA20137@sgi.com>
Subject: [tip:x86/uv] x86, uv: add Kconfig dependency on NUMA for UV systems
Message-ID: <tip-54c28d294c658abb6d6430a49fda230fdfd601c8@git.kernel.org>
Git-Commit-ID: 54c28d294c658abb6d6430a49fda230fdfd601c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 13:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54c28d294c658abb6d6430a49fda230fdfd601c8
Gitweb:     http://git.kernel.org/tip/54c28d294c658abb6d6430a49fda230fdfd601c8
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 3 Apr 2009 15:39:42 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 14:58:11 +0200

x86, uv: add Kconfig dependency on NUMA for UV systems

Impact: build fix

Add Kconfig dependency on NUMA for enabling UV. Although it might
be possible to configure non-NUMA UV systems, they are unsupported
and not interesting. Much of the infrastructure for UV requires
NUMA support.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090403203942.GA20137@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 748e50a..2817ab5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -354,6 +354,7 @@ config X86_UV
 	bool "SGI Ultraviolet"
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
 	select X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.

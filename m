Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZDYAPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZDYAPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZDYAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:15:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZDYAPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:15:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 17/17] arm: HAVE_ARCH_TRACEHOOK
Message-Id: <20090425001526.00397FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:15:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the prerequisites are in place, so wire up HAVE_ARCH_TRACEHOOK for arm.
The immediate effect of this is to make /proc/pid/syscall work.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e02b893..5b322d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_TRACEHOOK
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)

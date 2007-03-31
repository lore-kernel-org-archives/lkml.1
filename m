Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXCaIe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXCaIe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXCaIe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:34:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35707 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXCaIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:34:46 -0400
Message-Id: <20070331083408.910478000@sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] x86_64: enable dynticks
Content-Disposition: inline; filename=x86_64-enable-dynticks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Everything is in place, so give the CONFIG_NO_HZ option.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linus-2.6.orig/arch/x86_64/Kconfig
+++ linus-2.6/arch/x86_64/Kconfig
@@ -134,6 +134,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC

--

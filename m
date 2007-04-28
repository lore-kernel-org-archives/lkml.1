Return-Path: <linux-kernel-owner+w=401wt.eu-S1163329AbXD1RxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163329AbXD1RxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163327AbXD1RxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163312AbXD1Rwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:53 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [27/35] i386: Support Oprofile for AMD Family 10 CPUs
Message-Id: <20070428175252.B96CC151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/oprofile/nmi_int.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/i386/oprofile/nmi_int.c
===================================================================
--- linux.orig/arch/i386/oprofile/nmi_int.c
+++ linux/arch/i386/oprofile/nmi_int.c
@@ -414,6 +414,10 @@ int __init op_nmi_init(struct oprofile_o
 				   user space an consistent name. */
 				cpu_type = "x86-64/hammer";
 				break;
+			case 0x10:
+				model = &op_athlon_spec;
+				cpu_type = "x86-64/family10";
+				break;
 			}
 			break;
  

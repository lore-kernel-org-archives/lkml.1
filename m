Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbZINUTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbZINUTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933562AbZINUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:18:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42020 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbZINUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:06 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
In-Reply-To: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [3/5] kbuild: Echo the record_mcount command
Message-Id: <20090914201808.F406DB1757@basil.firstfloor.org>
Date: Mon, 14 Sep 2009 22:18:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had some problems with record_mcount in the Makefile and it was hard
to track down. Echo it by default to make it easier to diagnose.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/Makefile.build |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.31-rc1-ak/scripts/Makefile.build
===================================================================
--- linux-2.6.31-rc1-ak.orig/scripts/Makefile.build
+++ linux-2.6.31-rc1-ak/scripts/Makefile.build
@@ -216,6 +216,7 @@ define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
 	$(cmd_modversions)						  \
+	$(call echo-cmd,record_mcount)					  \
 	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \

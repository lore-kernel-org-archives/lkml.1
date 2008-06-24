Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbYFXPYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbYFXPYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYFXPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:24:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:31270 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYFXPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bZyu0wTMfPfgaGfBuZsyHgXII1QLR4xKhjUNEEz5VTmMXdfI9g002+Qb9sNqDjNCT7
         53e+vyY+c4QOKVOHBKRs6wagc3sZ/B68SJC+eGG5AYIyJ76sRa73/uLO9D00Mi/8Xcua
         5ryGF4BOsfRhpsX4lYF0KDnW09IdKcHRogDJQ=
Date: Tue, 24 Jun 2008 16:21:18 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Subject: [Patch] arch/x86/kernel/machine_kexec_32.c: remove extra semicolons
Message-ID: <20080624152118.GE10512@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I can't see any reason to keep these semicolons.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Ingo Molnar <mingo@redhat.com>

---
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index d0b234c..f496017 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -39,7 +39,7 @@ static void set_idt(void *newidt, __u16 limit)
 	curidt.address = (unsigned long)newidt;
 
 	load_idt(&curidt);
-};
+}
 
 
 static void set_gdt(void *newgdt, __u16 limit)
@@ -51,7 +51,7 @@ static void set_gdt(void *newgdt, __u16 limit)
 	curgdt.address = (unsigned long)newgdt;
 
 	load_gdt(&curgdt);
-};
+}
 
 static void load_segments(void)
 {

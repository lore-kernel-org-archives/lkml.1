Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHBTZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHBTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYHBTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:25:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:22126 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYHBTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Wv5D9ydjC6L469m4nz5YigUEIVZb2XPIP8BVjD1RlUjQdD1au+gafJ2hhPboCGScb8
         TVxjr9ybJ3SAahJAAR8SefXltcYYrmZpAsTZoYn9ovRfan+g7O9YfB5jE2dIdXgDa9Yg
         BiOrEzrJz9LuMqkRB6DxAO7tXCB8vmPv0ppoA=
Date: Sat, 2 Aug 2008 21:25:43 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa <hpa@zytor.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
Subject: [PATCH 5/5] x86: Coding style fixes to
 arch/x86/kernel/paravirt_patch_32.c
Message-ID: <20080802212543.763afaf6@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 3 errors, 1 warnings, 49 lines checked


After:
total: 2 errors, 1 warnings, 49 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/paravirt_patch_32.o.*
a78eea4264723e18c49dcfbe0ee0aae7  /tmp/paravirt_patch_32.o.after
a78eea4264723e18c49dcfbe0ee0aae7  /tmp/paravirt_patch_32.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/paravirt_patch_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
index 5826221..9fe644f 100644
--- a/arch/x86/kernel/paravirt_patch_32.c
+++ b/arch/x86/kernel/paravirt_patch_32.c
@@ -23,7 +23,7 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 			start = start_##ops##_##x;		\
 			end = end_##ops##_##x;			\
 			goto patch_site
-	switch(type) {
+	switch (type) {
 		PATCH_SITE(pv_irq_ops, irq_disable);
 		PATCH_SITE(pv_irq_ops, irq_enable);
 		PATCH_SITE(pv_irq_ops, restore_fl);
-- 
1.5.6.rc1.21.g03300


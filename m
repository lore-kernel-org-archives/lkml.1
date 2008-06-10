Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYFJROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYFJROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYFJRN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:13:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:31352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYFJRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=UZt2i6K4tTlxLelctvdHcN1AVU/IL9aajdTFi8SwMuwok7Fo/FBzsTeWn6vbXnX8Nb
         EIBjvu8TQrnBOgZWJ47dcNMOJGee09PSRbVcUC1PBrsRSGM9TaebwTyswtuG0nDaSicI
         PcrxvaS0qkBmyOdqWwUc+Z1sjCQ6DZ8YgnjJM=
Message-ID: <484EB61E.7050509@gmail.com>
Date: Tue, 10 Jun 2008 22:43:02 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: ananth@in.ibm.com, Masami Hiramatsu <mhiramat@redhat.com>,
       akpm@linux-foundation.org
Subject: [PATCH] kprobes: remove redundant config check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that there's a CONFIG_KPROBES check inside kernel/kprobes.c,
which seems redundant. Can be removed?

Diff'd against v2.6.26-rc5.


Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---
remove redundant CONFIG_KPROBES check.

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1e0250c..2b2cae2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1283,13 +1283,8 @@ EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(register_jprobes);
 EXPORT_SYMBOL_GPL(unregister_jprobes);
-#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
-#endif
-
-#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 EXPORT_SYMBOL_GPL(register_kretprobes);
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
-#endif

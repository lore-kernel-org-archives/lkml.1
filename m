Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZGAFHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZGAFHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZGAFHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:07:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZGAFHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:07:10 -0400
Date: Wed, 1 Jul 2009 01:06:46 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090701050900.6188.41697.sendpatchset@localhost.localdomain>
In-Reply-To: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
Subject: [Patch 3/3] elf: use a macro instead of a raw number
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use TASK_COMM_LEN instead of the raw number 16.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>

---
Index: linux-2.6/include/linux/elfcore.h
===================================================================
--- linux-2.6.orig/include/linux/elfcore.h
+++ linux-2.6/include/linux/elfcore.h
@@ -90,7 +90,7 @@ struct elf_prpsinfo
 	__kernel_gid_t	pr_gid;
 	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
-	char	pr_fname[16];	/* filename of executable */
+	char	pr_fname[TASK_COMM_LEN];/* filename of executable */
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
 

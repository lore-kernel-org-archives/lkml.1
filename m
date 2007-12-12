Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXLLPlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXLLPlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbXLLPji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:39:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbXLLPjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:39:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/19] provide tss_desc
Date: Wed, 12 Dec 2007 10:53:55 -0200
Message-Id: <11974641042757-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974640983333-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new type, tss_desc, to represent the tss descriptor
in a unified way accross x86_64 and i386

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc_defs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 5a58fc1..c4d7874 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -70,9 +70,11 @@ struct ldttss_desc64 {
 #ifdef CONFIG_X86_64
 typedef struct gate_struct64 gate_desc;
 typedef struct ldttss_desc64 ldt_desc;
+typedef struct ldttss_desc64 tss_desc;
 #else
 typedef struct desc_struct gate_desc;
 typedef struct desc_struct ldt_desc;
+typedef struct desc_struct tss_desc;
 #endif
 
 struct desc_ptr {
-- 
1.5.0.6


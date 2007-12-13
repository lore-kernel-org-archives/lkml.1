Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXLMEu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXLMEu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbXLMErP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:47:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758855AbXLMErI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:47:08 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/19] provide tss_desc
Date: Thu, 13 Dec 2007 00:01:43 -0200
Message-Id: <1197511363887-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975113583644-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11975113122984-git-send-email-gcosta@redhat.com> <11975113194101-git-send-email-gcosta@redhat.com> <11975113243875-git-send-email-gcosta@redhat.com> <11975113291722-git-send-email-gcosta@redhat.com> <1197511334416-git-send-email-gcosta@redhat.com> <1197511338810-git-send-email-gcosta@redhat.com> <1197511343355-git-send-email-gcosta@redhat.com> <11975113484194-git-send-email-gcosta@redhat.com> <11975113532186-git-send-email-gcosta@redhat.com> <11975113583644-git-send-email-gcosta@redhat.com>
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


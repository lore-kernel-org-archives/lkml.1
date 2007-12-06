Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXLFTGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXLFTGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXLFTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:02:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbXLFTCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:02:06 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 16/19] provide tss_desc
Date: Thu,  6 Dec 2007 14:16:37 -0200
Message-Id: <11969578811685-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578773678-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com> <11969578671479-git-send-email-gcosta@redhat.com> <119695787262-git-send-email-gcosta@redhat.com> <11969578773678-git-send-email-gcosta@redhat.com>
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
index 3bfb7d9..d4ae70d 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -80,9 +80,11 @@ struct ldttss_desc64 {
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
1.4.4.2


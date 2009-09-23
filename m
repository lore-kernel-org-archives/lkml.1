Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZIXAeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZIXAeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZIXAeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:34:06 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39153 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZIXAaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:30:05 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Nathan Lynch <ntl@pobox.com>
Subject: [PATCH v18 75/80] powerpc: reserve checkpoint arch identifiers
Date: Wed, 23 Sep 2009 19:51:55 -0400
Message-Id: <1253749920-18673-76-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 include/linux/checkpoint_hdr.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 9ae35a0..2ed523f 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -117,6 +117,8 @@ enum {
 	/* do not change order (will break ABI) */
 	CKPT_ARCH_X86_32 = 1,
 	CKPT_ARCH_S390X,
+	CKPT_ARCH_PPC32,
+	CKPT_ARCH_PPC64,
 };
 
 /* shared objrects (objref) */
-- 
1.6.0.4


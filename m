Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYHAWpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYHAWpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbYHAWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:42:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52146 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbYHAWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:41:58 -0400
Date: Fri, 1 Aug 2008 18:41:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH 8/14] missing export of csum_partial() on uml/amd64
Message-ID: <20080801224129.GA13733@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7282ca1a67ef596819e8cf5725b0caa95c5692f1 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/sys-x86_64/ksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/sys-x86_64/ksyms.c b/arch/um/sys-x86_64/ksyms.c
index 12c5936..08f63e2 100644
--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -14,3 +14,4 @@ EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
 EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(csum_partial);
-- 
1.5.5.1

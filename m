Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXDAOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXDAOsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXDAOfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:47531 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbXDAOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/41] KVM: Export <linux/kvm.h>
Date: Sun,  1 Apr 2007 17:35:01 +0300
Message-Id: <11754381382515-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438138805-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows users to actually build prgrams that use kvm without
the entire source tree.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e81e301..b35b593 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -99,6 +99,7 @@ header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
+header-y += kvm.h
 header-y += limits.h
 header-y += lock_dlm_plock.h
 header-y += magic.h
-- 
1.5.0.5


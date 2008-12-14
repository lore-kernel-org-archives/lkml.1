Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYLNIL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYLNIL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYLNIHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/36] KVM: Remove extraneous semicolon after do/while
Date: Sun, 14 Dec 2008 10:06:44 +0200
Message-Id: <1229242029-13410-12-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notices by Guillaume Thouvenin.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index e8c87cc..69b330b 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -374,7 +374,7 @@ static u16 group2_table[] = {
 			: "=m" (_eflags), "=m" ((_dst).val),		\
 			  "=&r" (_tmp)					\
 			: _y ((_src).val), "i" (EFLAGS_MASK));		\
-	} while (0);
+	} while (0)
 
 
 /* Raw emulation: instruction has two explicit operands. */
-- 
1.6.0.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYIYMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYIYMCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYIYLz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbYIYLz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, roel kluin <roel.kluin@gmail.com>
Subject: [PATCH 20/39] KVM: x86 emulator: remove duplicate SrcImm
Date: Thu, 25 Sep 2008 14:54:52 +0300
Message-Id: <1222343711-12508-21-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: roel kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d5da7f1..5d6c144 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -269,7 +269,7 @@ static u16 group_table[] = {
 	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group3*8] =
-	DstMem | SrcImm | ModRM | SrcImm, 0,
+	DstMem | SrcImm | ModRM, 0,
 	DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group4*8] =
-- 
1.6.0.1


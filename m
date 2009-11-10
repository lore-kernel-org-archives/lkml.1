Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZKJUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZKJUz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZKJUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:55:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:52330 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081AbZKJUzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:55:25 -0500
Date: Tue, 10 Nov 2009 20:55:08 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20091110200120.GA27090@redhat.com>
References: <20091110200120.GA27090@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix typo in Intel CPU cache size descriptor
Message-ID: <tip-e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149@git.kernel.org>
Git-Commit-ID: e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149
Gitweb:     http://git.kernel.org/tip/e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 10 Nov 2009 15:01:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 21:52:32 +0100

x86: Fix typo in Intel CPU cache size descriptor

I double-checked the datasheet. One of the existing
descriptors has a typo: it should be 2MB not 2038 KB.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: <stable@kernel.org> # .3x.x: 85160b9: x86: Add new Intel CPU cache size descriptors
Cc: <stable@kernel.org> # .3x.x
LKML-Reference: <20091110200120.GA27090@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1410392..8178d03 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -94,7 +94,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
 	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */

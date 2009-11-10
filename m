Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZKJTJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZKJTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZKJTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:09:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:41765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZKJTJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:09:55 -0500
Date: Tue, 10 Nov 2009 19:09:39 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20091110184924.GA20337@redhat.com>
References: <20091110184924.GA20337@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add new Intel CPU cache size descriptors
Message-ID: <tip-85160b92fbd35321104819283c91bfed2b553e3c@git.kernel.org>
Git-Commit-ID: 85160b92fbd35321104819283c91bfed2b553e3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85160b92fbd35321104819283c91bfed2b553e3c
Gitweb:     http://git.kernel.org/tip/85160b92fbd35321104819283c91bfed2b553e3c
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 10 Nov 2009 13:49:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 20:06:16 +0100

x86: Add new Intel CPU cache size descriptors

The latest rev of Intel doc AP-485 details new cache descriptors
that we don't yet support. 12MB, 18MB and 24MB 24-way assoc L3
caches.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20091110184924.GA20337@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..1410392 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -102,6 +102,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 

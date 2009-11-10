Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbZKJFQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbZKJFQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZKJFQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:16:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:51728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZKJFQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:16:57 -0500
Date: Tue, 10 Nov 2009 05:16:29 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257818330.12852.72.camel@Joe-Laptop.home>
References: <1257818330.12852.72.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: GART: pci-gart_64.c: Use correct length in strncmp
Message-ID: <tip-41855b77547fa18d90ed6a5d322983d3fdab1959@git.kernel.org>
Git-Commit-ID: 41855b77547fa18d90ed6a5d322983d3fdab1959
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41855b77547fa18d90ed6a5d322983d3fdab1959
Gitweb:     http://git.kernel.org/tip/41855b77547fa18d90ed6a5d322983d3fdab1959
Author:     Joe Perches <joe@perches.com>
AuthorDate: Mon, 9 Nov 2009 17:58:50 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 06:05:39 +0100

x86: GART: pci-gart_64.c: Use correct length in strncmp

Signed-off-by: Joe Perches <joe@perches.com>
Cc: <stable@kernel.org> # .3x.x
LKML-Reference: <1257818330.12852.72.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-gart_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a9bcdf7..eb46ab3 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -858,7 +858,7 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
+	if (!strncmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
 	if (!strncmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;

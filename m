Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbXD0S47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbXD0S47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbXD0S46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:56:58 -0400
Received: from mail.suse.de ([195.135.220.2]:50523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbXD0S4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/46] powerpc: make it compile for multithread change
Date: Fri, 27 Apr 2007 11:53:23 -0700
Message-Id: <1177700070961-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000663361-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

arch/powerpc/kernel/of_platform.c:479: error: unknown field `multithread_probe' specified in initializer

Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/of_platform.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index b734517..9e7a4d2 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -475,9 +475,6 @@ static struct of_platform_driver of_pci_phb_driver = {
        .name = "of-pci",
        .match_table = of_pci_phb_ids,
        .probe = of_pci_phb_probe,
-       .driver = {
-	       .multithread_probe = 1,
-       },
 };
 
 static __init int of_pci_phb_init(void)
-- 
1.5.1.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbZB0Kgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbZB0Kgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZB0K2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/37] KVM: SVM: Fix typo in has_svm()
Date: Fri, 27 Feb 2009 12:26:51 +0200
Message-Id: <1235730420-7929-29-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3a60c3f..db5021b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -250,7 +250,7 @@ static int has_svm(void)
 	const char *msg;
 
 	if (!cpu_has_svm(&msg)) {
-		printk(KERN_INFO "has_svn: %s\n", msg);
+		printk(KERN_INFO "has_svm: %s\n", msg);
 		return 0;
 	}
 
-- 
1.6.0.6


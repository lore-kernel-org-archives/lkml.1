Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbZHGJvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbZHGJvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbZHGJvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:51:08 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:8996 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932357AbZHGJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:51:00 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KO03BD-04-L8L-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/21] kvm/svm: enable nested svm by default
Date: Fri, 7 Aug 2009 11:49:48 +0200
Message-ID: <1249638588-10982-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0311 (UTC) FILETIME=[68923DF0:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nested SVM is (in my experience) stable enough to be enabled by
default. So omit the requirement to pass a module parameter.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8b32cc8..8a28956 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -125,7 +125,7 @@ static int npt = 1;
 
 module_param(npt, int, S_IRUGO);
 
-static int nested = 0;
+static int nested = 1;
 module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
-- 
1.6.3.3



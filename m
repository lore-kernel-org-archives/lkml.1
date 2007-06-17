Return-Path: <linux-kernel-owner+w=401wt.eu-S1762702AbXFQKDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762702AbXFQKDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbXFQJpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:55202 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759003AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 26/58] KVM: VMX: Cleanup redundant code in MSR set
Date: Sun, 17 Jun 2007 12:44:07 +0300
Message-Id: <1182073480225-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 872ca03..dc99191 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -643,8 +643,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 			break;
 		}
 		return kvm_set_msr_common(vcpu, msr_index, data);
-		msr->data = data;
-		break;
 	}
 
 	return 0;
-- 
1.5.0.6


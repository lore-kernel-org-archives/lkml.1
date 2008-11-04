Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYKDOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYKDOzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYKDOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbYKDOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:41 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 12/16] kvm: svm: set crash_hardware_disable to svm_hardware_disable
Date: Tue,  4 Nov 2008 12:52:40 -0200
Message-Id: <1225810364-8990-13-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use it as is, as it is a simple function.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/svm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f0ad4d4..6b3a660 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1942,6 +1942,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
+	.crash_hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 
 	.vcpu_create = svm_create_vcpu,
-- 
1.5.5.GIT


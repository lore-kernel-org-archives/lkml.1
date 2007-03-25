Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXCYP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXCYP7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXCYP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:59:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:35187 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXCYP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Kc25UUtPlwwwjMWgy4jFT7WLo5590CaIWMlrYS1GlaYTqGZugfDLOlcCn3fqKKSkL8hMBI6+GU0JA6l5w8l9eIEC7Gwr/OzsS5S3bEMatTvAXUaX6tdZWqrFRs7/cf7fSMr1ZS/0RAahXN96/wmCbqrnBIqWLD7yMZse7BJUi0w=
Message-ID: <46069C64.6020105@googlemail.com>
Date: Sun, 25 Mar 2007 17:59:32 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>, Yaniv Kamay <yaniv@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] drivers/kvm/svm.c remove unused function
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function

CC      drivers/kvm/svm.o
drivers/kvm/svm.c:207: warning: ‘inject_db’ defined but not used

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work5/drivers/kvm/svm.c	2007-03-25 00:31:07.000000000 +0100
+++ linux-work3/drivers/kvm/svm.c	2007-03-25 14:20:08.000000000 +0200
@@ -203,13 +203,6 @@ static void inject_ud(struct kvm_vcpu *v
 						UD_VECTOR;
 }
 
-static void inject_db(struct kvm_vcpu *vcpu)
-{
-	vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-						SVM_EVTINJ_TYPE_EXEPT |
-						DB_VECTOR;
-}
-
 static int is_page_fault(uint32_t info)
 {
 	info &= SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;

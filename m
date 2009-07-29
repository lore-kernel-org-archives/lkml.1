Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZG2M5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZG2M5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZG2M5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:30 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:33965
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754959AbZG2M51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:57:27 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNJNYL-03-5SW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/12] Nested SVM cleanups
Date: Wed, 29 Jul 2009 14:56:20 +0200
Message-ID: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0639 (UTC) FILETIME=[01BFDAF0:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a first round of patches to clean up the code for SVM virtualization
for KVM on AMD. There is more to clean up but since I am on vacation the rest
of the week here is what I have queued up so far. Maybe this saves me from
rebasing this code next week ;-)
I tested these patches with KVM in KVM and it works stable with and without
nested SMP. It doesn't seem to break anything.

	Joerg

Diffstat:

 arch/x86/kvm/svm.c |  422 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 256 insertions(+), 166 deletions(-)

Shortlog:

Joerg Roedel (12):
      kvm/svm: make nested svm debugging runtime configurable
      kvm/svm: add helper functions for global interrupt flag
      kvm/svm: optimize nested #vmexit
      kvm/svm: optimize nested vmrun
      kvm/svm: copy only necessary parts of the control area on vmrun/vmexit
      kvm/svm: complete interrupts after handling nested exits
      kvm/svm: move nested svm state into seperate struct
      kvm/svm: cache nested intercepts
      kvm/svm: consolidate nested_svm_exit_handled
      kvm/svm: do nested vmexit in nested_svm_exit_handled
      kvm/svm: handle #pf intercepts in nested_svm_exit_handled directly
      kvm/svm: simplify nested_svm_check_exception



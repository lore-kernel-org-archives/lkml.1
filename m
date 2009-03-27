Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZC0Och@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZC0Och (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZC0OcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:19 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:23637 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC0OcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:17 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KH65PA-02-E3O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Support for GB pages in KVM
Date: Fri, 27 Mar 2009 15:31:52 +0100
Message-ID: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0212 (UTC) FILETIME=[CA0AC940:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset extends the KVM MMU implementation to support 1GB pages as
supported by AMD family 16 processors. These patches enable support for
1 GB pages with Nested Paging. Support for these pages in the shadow
paging code was also developed but does not run stable yet. The patch
for shadow-paging support is not included in this series and will be
sent out seperatly.

Joerg

git diff --stat avi/master..

 arch/ia64/kvm/process.c         |    5 -
 arch/ia64/kvm/vmm_ivt.S         |   18 ++--
 arch/ia64/kvm/vtlb.c            |    3 +-
 arch/x86/include/asm/kvm_host.h |   29 ++++-
 arch/x86/kvm/mmu.c              |  232 +++++++++++++++++++++++++++------------
 arch/x86/kvm/paging_tmpl.h      |   48 ++++++---
 arch/x86/kvm/svm.c              |    7 +
 arch/x86/kvm/vmx.c              |   19 ++-
 arch/x86/kvm/x86.c              |    6 +-
 include/linux/kvm.h             |    1 +
 include/linux/kvm_host.h        |    2 +-
 mm/hugetlb.c                    |    1 +
 virt/kvm/kvm_main.c             |   26 +++++




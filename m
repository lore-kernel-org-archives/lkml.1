Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZGGQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZGGQmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZGGQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:41:41 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34734 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbZGGQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:41:38 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMF7OW-04-HXD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6 v4] KVM support for 1GB pages
Date: Tue, 7 Jul 2009 18:41:01 +0200
Message-ID: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 07 Jul 2009 16:41:16.0568 (UTC) FILETIME=[BF534980:01C9FF21]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the forth version of the patches for KVM to support 1GB pages.
This code still only can make use of 1GB pages with nested paging
enabled. I will give the shadow paging code another debug round soon.
Please comment or consider to apply these patches.

Thanks,
	
	Joerg

shortlog:

Joerg Roedel (6):
      kvm/mmu: make rmap code aware of mapping levels
      kvm/mmu: rename is_largepage_backed to mapping_level
      kvm/mmu: make direct mapping paths aware of mapping levels
      kvm/mmu: make page walker aware of mapping levels
      kvm/mmu: enable gbpages by increasing nr of pagesizes
      kvm x86: report 1GB page support to userspace

diffstat:

 arch/x86/include/asm/kvm_host.h |    6 +-
 arch/x86/kvm/mmu.c              |  234 ++++++++++++++++++++++++--------------
 arch/x86/kvm/paging_tmpl.h      |   62 ++++++-----
 arch/x86/kvm/svm.c              |    6 +
 arch/x86/kvm/vmx.c              |    6 +
 arch/x86/kvm/x86.c              |    3 +-
 6 files changed, 199 insertions(+), 118 deletions(-)



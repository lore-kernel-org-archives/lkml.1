Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbZCaACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbZCaACd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZCaABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:01:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760416AbZCaABJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:01:09 -0400
From: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 0/3] kvm support for ksm
Date: Tue, 31 Mar 2009 03:00:01 +0300
Message-Id: <1238457604-7637-1-git-send-email-ieidus@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apply it against Avi git tree.

Izik Eidus (3):
  kvm: dont hold pagecount reference for mapped sptes pages.
  kvm: add SPTE_HOST_WRITEABLE flag to the shadow ptes.
  kvm: add support for change_pte mmu notifiers

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   89 ++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/paging_tmpl.h      |   16 ++++++-
 virt/kvm/kvm_main.c             |   14 ++++++
 4 files changed, 101 insertions(+), 19 deletions(-)


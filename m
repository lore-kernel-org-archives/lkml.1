Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbYFYErw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbYFYErw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYFYEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:49 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37481 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756034AbYFYEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 36] x86: asm-x86/pgtable.h: fix compiler warning
X-Mercurial-Node: 6fa49a4d5d7dd5b91dd4282fb6de8e904d0d96d4
Message-Id: <6fa49a4d5d7dd5b91dd4.1214367537@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:18:57 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -425,6 +425,8 @@
  * race with other CPU's that might be updating the dirty
  * bit at the same time.
  */
+struct vm_area_struct;
+
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,



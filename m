Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYFYEpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYFYEpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYFYEhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:37 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37438 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755370AbYFYEhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 36] x86-64: add FIX_PARAVIRT_BOOTMAP fixmap slot
X-Mercurial-Node: 45f2a8212d4b36b1821b50b89a211f37b266b1c0
Message-Id: <45f2a8212d4b36b1821b.1214367557@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:17 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This matches 32 bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/fixmap_64.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -46,6 +46,9 @@
 	FIX_EFI_IO_MAP_LAST_PAGE,
 	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
 				  + MAX_EFI_IO_PAGES - 1,
+#ifdef CONFIG_PARAVIRT
+	FIX_PARAVIRT_BOOTMAP,
+#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif



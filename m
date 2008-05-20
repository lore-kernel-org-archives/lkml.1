Return-Path: <linux-kernel-owner+w=401wt.eu-S1764698AbYETJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698AbYETJIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763024AbYETJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:56 -0400
Received: from gw.goop.org ([64.81.55.164]:44075 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762375AbYETJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:55 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 8] x86: clarify use of _PAGE_CHG_MASK
X-Mercurial-Node: c35204feb639fc3dada66c722e41426f04d8f1ae
Message-Id: <c35204feb639fc3dada6.1211268382@localhost>
In-Reply-To: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:22 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_CHG_MASK is defined as the set of bits not updated by
pte_modify(); specifically, the pfn itself, and the Accessed and Dirty
bits (which are updated by hardware).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -57,6 +57,7 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
+/* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
 



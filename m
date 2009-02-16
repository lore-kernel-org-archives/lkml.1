Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZBPAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZBPAu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZBPAuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:50:17 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:41720 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZBPAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:50:16 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: glommer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] x86: fixmap.h x86 integration
Date: Sun, 15 Feb 2009 21:48:51 -0300
Message-Id: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These patches unify the fixmap_(32|64).h into fixmap.h.
Some things was left with '#ifdef CONFIG_X86_(32|64)' because first we
need to integrate things like vsyscall, efi, pci_mmconfig, FIXADDR_TOP
and FIX_WP_TEST.
I spplited the last patch in three patches, now the unification is mechanic.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>

 arch/x86/include/asm/fixmap.h    |  149 +++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/fixmap_32.h |  115 -----------------------------
 arch/x86/include/asm/fixmap_64.h |   79 --------------------
 arch/x86/mm/pgtable.c            |   18 +++++
 arch/x86/mm/pgtable_32.c         |   16 ----
 5 files changed, 165 insertions(+), 212 deletions(-)



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZBEWrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZBEWrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBEWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:47:11 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:56336 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752898AbZBEWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:47:10 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 0/6] x86: fixmap.h x86 integration
Date: Thu,  5 Feb 2009 20:39:40 -0200
Message-Id: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches unify the fixmap_(32|64).h into fixmap.h. I reworked they
on top of last change into fixmap code.
Some things was left with '#ifdef CONFIG_X86_(32|64)' because first we
need to integrate things like vsyscall, efi, pci_mmconfig, FIXADDR_TOP
and FIX_WP_TEST.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>


 arch/x86/include/asm/fixmap.h    |  153 +++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/fixmap_32.h |  119 -----------------------------
 arch/x86/include/asm/fixmap_64.h |   83 --------------------
 arch/x86/mm/pgtable.c            |   18 +++++
 arch/x86/mm/pgtable_32.c         |   16 ----
 5 files changed, 169 insertions(+), 220 deletions(-)





Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYBIMDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYBIMDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYBIMDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:03:09 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61160 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYBIMDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:03:06 -0500
Message-Id: <20080209120157.885371603@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Sat, 09 Feb 2008 13:01:57 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/11] s390 patch set #3 for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the third s390 patch set for 2.6.25 and the last one with new features.
With this the overhaul of the memory management definitions for s390
is complete. The "1K/2K page table pages" patch removes the hack that
a pmd_t contains more than one pointer. This makes the code a lot
simpler and it allows to do clever things like dynamic page tables --
which increases the code complexity again ;-).

The shortlog:

Christian Borntraeger (1):
      [S390] sclp_vt220: Fix vt220 initialization

Felix Beck (1):
      [S390] zcrypt: Do not start ap poll thread per default

Martin Schwidefsky (8):
      [S390] Update default configuration.
      [S390] Wire up new timerfd syscalls.
      [S390] Fix __ffs_word_loop/__ffz_word_loop inlnie assembly.
      [S390] VMEM_MAX_PHYS overflow on 31 bit.
      [S390] Remove a.out header file.
      [S390] 1K/2K page table pages.
      [S390] Add four level page tables for CONFIG_64BIT=y.
      [S390] dynamic page tables.

Ursula Braun (1):
      [S390] qdio: avoid hang when establishing qdio queues

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


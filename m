Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYBEPja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYBEPja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYBEPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:39:14 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40337 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYBEPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:39:12 -0500
Message-Id: <20080205153835.337897404@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Feb 2008 16:38:35 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/18] s390 bug fix patches.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shortlog says is all:

Christian Borntraeger (1):
      [S390] sclp_tty/sclp_vt220: Fix scheduling while atomic

Cornelia Huck (3):
      [S390] cio: Clean up chsc response code handling.
      [S390] cio: Update documentation.
      [S390] cio: Add shutdown callback for ccwgroup.

Heiko Carstens (8):
      [S390] DEBUG_PAGEALLOC support for s390.
      [S390] Fix linker script.
      [S390] Fix smp_call_function_mask semantics.
      [S390] Fix couple of section mismatches.
      [S390] Implement ext2_find_next_bit.
      [S390] latencytop s390 support.
      [S390] Remove BUILD_BUG_ON() in vmem code.
      [S390] dcss: Initialize workqueue before using it.

Martin Schwidefsky (2):
      [S390] Define GENERIC_LOCKBREAK.
      [S390] Cleanup & optimize bitops.

Peter Oberparleiter (2):
      [S390] cio: make sense id procedure work with partial hardware response
      [S390] console: allow vt220 console to be the only console

Stefan Haberland (1):
      [S390] dasd: add ifcc handling

Stefan Weinhuber (1):
      [S390] dasd: fix panic caused by alias device offline


The only notable changes are the DEBUG_PAGEALLOC and the latencytop
support. Have fun.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


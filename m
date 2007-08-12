Return-Path: <linux-kernel-owner+w=401wt.eu-S1764828AbXHLDYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764828AbXHLDYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXHLDYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:24:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58555 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXHLDYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:24:16 -0400
Date: Sun, 12 Aug 2007 12:23:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.23-rc3
Message-ID: <20070812032314.GA13496@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.23.git

Which contains:

Paul Mundt (3):
      sh: Fix PTRACE_PEEKTEXT/PEEKDATA fallout from generic_ptrace_peekdata().
      sh: panic on machvec section misalignment.
      sh: Add missing dma_sync_single_range_for_*().

 arch/sh/kernel/machvec.c     |    7 +++++++
 arch/sh/kernel/ptrace.c      |    1 +
 include/asm-sh/dma-mapping.h |   19 +++++++++++++++++++
 3 files changed, 27 insertions(+)

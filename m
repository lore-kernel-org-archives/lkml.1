Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0CODgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:36:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51951 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0CODgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:36:31 -0400
Date: Mon, 15 Mar 2010 12:35:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.34-rc2
Message-ID: <20100315033534.GA14501@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Huang Weiyi (1):
      serial: sh-sci: remove duplicated #include

Paul Mundt (4):
      sh: Support CPU affinity masks for INTC controllers.
      sh: Fix up uncached offset for legacy 29-bit mode.
      sh: Fix up NUMA build for 29-bit.
      sh: Export uncached helper symbols.

Peter Huewe (1):
      serial: sh-sci: Fix build failure for non-sh architectures.

 arch/sh/include/asm/mmu.h  |    7 +++++++
 arch/sh/mm/uncached.c      |    9 +++++++++
 drivers/serial/sh-sci.c    |    1 -
 drivers/sh/intc.c          |   31 ++++++++++++++++++++++++++++++-
 include/linux/serial_sci.h |    4 ++++
 5 files changed, 50 insertions(+), 2 deletions(-)

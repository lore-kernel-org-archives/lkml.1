Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZGGUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZGGUq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZGGUqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:46:19 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44305 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZGGUqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:46:18 -0400
Date: Wed, 8 Jul 2009 05:46:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc3
Message-ID: <20090707204600.GA24726@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.31

Which contains:

Magnus Damm (3):
      sh-sci: update receive error handling for muxed irqs
      usb: allow sh7724 to enable on-chip r8a66597
      sh: add r8a66597 usb0 host to the se7724 board

Paul Mundt (4):
      sh: define PERF_COUNTER_INDEX_OFFSET.
      video: sh_mobile_lcdcfb: Convert to framebuffer_alloc().
      video: hitfb: Convert to framebuffer_alloc().
      video: hitfb: Move over to dev_pm_ops.

SUGIOKA Toshinobu (1):
      serial: sh-sci: fix sci interrupt handler

 arch/sh/boards/mach-se/7724/setup.c |   38 ++++++++++++++++++++
 arch/sh/include/asm/perf_counter.h  |    2 +
 drivers/serial/sh-sci.c             |   11 +++---
 drivers/usb/host/Kconfig            |    4 +-
 drivers/video/hitfb.c               |   66 +++++++++++++++++++++++-----------
 drivers/video/sh_mobile_lcdcfb.c    |   40 +++++++++++++--------
 6 files changed, 116 insertions(+), 45 deletions(-)

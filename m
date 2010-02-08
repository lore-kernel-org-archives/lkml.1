Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0BHCYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 21:24:55 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41005 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab0BHCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 21:24:53 -0500
Date: Mon, 8 Feb 2010 11:24:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc8
Message-ID: <20100208022437.GC6839@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up a number of crashes both with the unwinder and with booting
from USB mass storage on certain CPUs. While the unwinder fixups aren't
technically regression fixes, they address a fairly long-standing set of
bugs. The HCD changes fix a fairly long-standing regression that was only
recently reported.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Matt Fleming (4):
      sh: Correct the offset of the return address in ret_from_exception
      sh: Setup frame pointer in handle_exception path
      sh: Don't continue unwinding across interrupts
      sh: Remove superfluous setup_frame_reg call

Paul Mundt (2):
      usb: r8a66597-hcd: Flush the D-cache for the pipe-in transfer buffers.
      usb: r8a66597-hcd: Fix up spinlock recursion in root hub polling.

 arch/sh/kernel/cpu/sh3/entry.S  |    3 +-
 arch/sh/kernel/dwarf.c          |   20 +++++++++++++++++++
 arch/sh/kernel/entry-common.S   |    8 ++++++-
 drivers/usb/host/r8a66597-hcd.c |   41 +++++++++++++++++++++++++++-----------
 4 files changed, 58 insertions(+), 14 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYEZKLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYEZKLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYEZKK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:10:59 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:29669 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309AbYEZKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:10:58 -0400
Date: Mon, 26 May 2008 19:09:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc4
Message-ID: <20080526100916.GA18102@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.26.git

Which contains:

Magnus Damm (5):
      sh: fix USBF resource for sh7722
      sh: fix VPU interrupt vector for sh7723
      sh: add probe support for new sh7723 cut
      sh: use sm501 8250 mfd support on r2d boards
      sh: update Migo-R defconfig

Paul Mundt (1):
      sh: Drop broken URAM support on SH7723.

 arch/sh/Kconfig                           |    1 -
 arch/sh/boards/renesas/rts7751r2d/setup.c |   39 +----
 arch/sh/configs/migor_defconfig           |  294 +++++++++++++++++++++++------
 arch/sh/kernel/cpu/sh4/probe.c            |    1 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c    |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c    |    8 +-
 6 files changed, 241 insertions(+), 104 deletions(-)

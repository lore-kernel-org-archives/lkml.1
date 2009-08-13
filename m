Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZHMDF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZHMDF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZHMDF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:05:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32866 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZHMDFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:05:55 -0400
Date: Thu, 13 Aug 2009 12:05:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc6
Message-ID: <20090813030556.GE2701@linux-sh.org>
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

Here are a couple of fixes for initcall ordering that fix up the recent
changes with the i2c reordering. All of these have been stewing in my
-next branch for some time, and only became .31 material when the i2c
changes were merged. In any event, there should be no real surprises
here.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.31

Which contains:

Magnus Damm (3):
      sh: convert processor device setup functions to arch_initcall()
      sh: fix i2c init order on Migo-R V2
      sh: fix i2c init order on ap325rxa V2

 arch/sh/boards/board-ap325rxa.c        |    2 +-
 arch/sh/boards/mach-migor/setup.c      |    2 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c  |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c    |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c  |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c  |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c  |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c  |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c  |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c  |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |    2 +-
 arch/sh/kernel/cpu/sh5/setup-sh5.c     |    2 +-
 26 files changed, 26 insertions(+), 26 deletions(-)

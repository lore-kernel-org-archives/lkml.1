Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYHTE0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYHTE0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 00:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYHTE01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 00:26:27 -0400
Received: from ozlabs.org ([203.10.76.45]:38607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYHTE00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 00:26:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18603.37996.974247.668984@cargo.ozlabs.ibm.com>
Date: Wed, 20 Aug 2008 13:50:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more bug-fixes for powerpc.

Paul.

 arch/powerpc/kernel/crash_dump.c          |   31 +++++++++++++++++++++--------
 arch/powerpc/kernel/ibmebus.c             |   12 -----------
 arch/powerpc/kernel/vio.c                 |    2 +-
 arch/powerpc/platforms/cell/spufs/run.c   |   15 +++++++-------
 arch/powerpc/platforms/cell/spufs/sched.c |   11 ++++++++--
 drivers/of/device.c                       |   10 +++++++++
 6 files changed, 50 insertions(+), 31 deletions(-)

Brian King (1):
      powerpc: Fix vio_bus_probe oops on probe error

Ilpo Järvinen (1):
      powerpc/spufs: Remove invalid semicolon after if statement

Jeremy Kerr (2):
      powerpc/spufs: fix npc setting for NOSCHED contexts
      powerpc/spufs: reference context while dropping state mutex in scheduler

Joachim Fenkes (1):
      powerpc/ibmebus: Restore "name" sysfs attribute on ibmebus devices

Michael Ellerman (1):
      powerpc: Fix /dev/oldmem interface for kdump


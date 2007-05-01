Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXEARD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXEARD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXEARD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:03:58 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43221 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857AbXEARD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:03:57 -0400
Subject: [GIT PATCH] Voyager updates for 2.6.21
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 12:03:23 -0500
Message-Id: <1178039003.4320.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This basically gets voyager compiling, working and ship shape again. The
only change to code outside of voyager is a clockevents fix that has
been ack'd by Thomas Gleixner. The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/voyager-2.6.git

The short changelog is:

Christoph Hellwig (1):
      [VOYAGER] Convert the monitor thread to use the kthread API

Eric W. Biederman (1):
      [VOYAGER] Use modern techniques to setup and teardown low identiy mappings

James Bottomley (4):
      [VOYAGER] add smp alternatives
      [VOYAGER] clockevents driver: bring voyager in to line
      [VOYAGER] clockevents: correct boot cpu is zero assumption
      [VOYAGER] add smp_call_function_single


and the diffstat:

 arch/i386/kernel/i8253.c                |    2 
 arch/i386/mach-voyager/setup.c          |    8 ++
 arch/i386/mach-voyager/voyager_cat.c    |    4 -
 arch/i386/mach-voyager/voyager_smp.c    |   97 +++++++++++++++++---------------
 arch/i386/mach-voyager/voyager_thread.c |   69 ++++++----------------
 include/asm-i386/voyager.h              |    6 -
 6 files changed, 84 insertions(+), 102 deletions(-)

James



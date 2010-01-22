Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412Ab0AVE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0AVE4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794Ab0AVEw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:52:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1333 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab0AVEw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:56 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/24] drivers/block/floppy.c cleanups
Date: Thu, 21 Jan 2010 20:52:30 -0800
Message-Id: <cover.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Stephen Hemminger is a bit too busy to do much with this
I've broken up the first large patch into multiple pieces and
brought the rest up to current.

I dropped the c99 conversions because Bartlomiej Zolnierkiewicz
objected.

This applies against Linus' and -next.

Maybe somebody will decide it's useful.

Original submissions:
http://lkml.org/lkml/2009/11/30/511
http://lkml.org/lkml/2009/12/2/14

Joe Perches (24):
  drivers/block/floppy.c: Convert some #include <asm/ to #include <linux/
  drivers/block/floppy.c: #define space and column neatening
  drivers/block/floppy.c: Use pr_<level>
  drivers/block/floppy.c: Remove unnecessary braces
  drivers/block/floppy.c: Remove used once CHECK_READY macro
  drivers/block/floppy.c: Hoist assigns from if()s, neatening
  drivers/block/floppy.c: Remove LAST_OUT macro
  drivers/block/floppy.c: Comment neatening and remove naked ;
  drivers/block/floppy.c: Remove CLEARSTRUCT macro, use memset
  drivers/block/floppy.c: Indent a comment
  drivers/block/floppy.c: Remove IN/OUT macros, indent switch/case
  drivers/block/floppy.c: Remove a few spaces from function casts
  drivers/block/floppy.c: Remove macro LOCK_FDC
  drivers/block/floppy.c: Add debug_dcl(...) macro
  drivers/block/floppy.c: Remove [U]CLEARF, [U]SETF, and [U]TESTF macros
  drivers/block/floppy.c: Remove most uses of CALL and ECALL macros
  drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
  drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
  drivers/block/floppy.c: convert int 1/0 to bool true/false
  drivers/block/floppy.c: Move leading && and || to preceding line
  drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
  drivers/block/floppy.c: Convert int initialising to bool initialized
  drivers/block/floppy.c: Add function is_ready_state
  drivers/block/floppy.c: Remove unnecessary return and braces

 drivers/block/floppy.c | 1219 ++++++++++++++++++++++++------------------------
 1 files changed, 618 insertions(+), 601 deletions(-)


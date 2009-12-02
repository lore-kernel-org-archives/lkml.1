Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZLBGHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZLBGHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZLBGHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1216 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZLBGHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:48 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 00/13] drivers/block/floppy.c: More cleanups
Date: Tue,  1 Dec 2009 22:07:40 -0800
Message-Id: <cover.1259733456.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might as well make it cleaner...

Joe Perches (13):
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
  drivers/block/floppy.c: Readd SunOS eject cmd comment
  drivers/block/floppy.c: Remove unnecessary return and braces

 drivers/block/floppy.c |  410 ++++++++++++++++++++++++------------------------
 1 files changed, 208 insertions(+), 202 deletions(-)


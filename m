Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496Ab0A0Uqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0A0Uqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424Ab0A0Uqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1515 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab0A0Uqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 00/13] drivers/block/floppy.c cleanups
Date: Wed, 27 Jan 2010 12:46:16 -0800
Message-Id: <cover.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some additional cleanups, and a restoration of output logging style
for one printk->DPRINT conversion

Joe Perches (13):
  drivers/block/floppy.c: Remove REPEAT macro
  drivers/block/floppy.c: Unclutter redo_fd_request logic
  drivers/block/floppy.c: Remove unnecessary argument from [__]reschedule_timeout
  drivers/block/floppy.c: Remove #define FLOPPY_SANITY_CHECK
  drivers/block/floppy.c: DPRINT neatening
  drivers/block/floppy.c: Use __func__ where appropriate
  drivers/block/floppy.c: Use %pf in logging messages
  drivers/block/floppy.c: Remove some unnecessary casting
  drivers/block/floppy.c: Convert raw_cmd_copyin from while(1) to label: goto
  drivers/block/floppy.c: Add __func__ to debugt
  drivers/block/floppy.c: Remove obfuscating CODE2SIZE macro
  drivers/block/floppy.c: Remove misleading, used once FD_IOCTL_ALLOWED macro
  drivers/block/floppy.c: Remove unnecessary casting in fd_ioctl

 drivers/block/floppy.c |  346 +++++++++++++++++++++--------------------------
 1 files changed, 155 insertions(+), 191 deletions(-)


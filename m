Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbXJNVXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbXJNVXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXJNVXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:23:23 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:37327 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbXJNVXW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:23:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: menuconfig: fail with clearer error if curses.h N/A
Date: Sun, 14 Oct 2007 23:23:20 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710142323.21139.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2007 21:23:20.0939 (UTC) FILETIME=[71F75BB0:01C80EA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice if 'make menuconfig' could fail earlier or with a clearer
error if curses.h is not available. The actual error is currently rather
buried in a huge amount of indirect errors.

After installing libncurses-dev (Debian) everything was fine.

$ make menuconfig
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
In file included from scripts/kconfig/lxdialog/checklist.c:24:
scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file or directory
In file included from scripts/kconfig/lxdialog/checklist.c:24:
scripts/kconfig/lxdialog/dialog.h:97: error: expected specifier-qualifier-list before ‘chtype’
scripts/kconfig/lxdialog/dialog.h:187: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:194: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:196: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:197: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:198: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:199: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/dialog.h:201: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/checklist.c:31: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/checklist.c:59: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/checklist.c:95: error: expected ‘)’ before ‘*’ token
scripts/kconfig/lxdialog/checklist.c: In function ‘dialog_checklist’:
[another 30 or so lines with warnings/errors omitted]

Cheers,
FJP

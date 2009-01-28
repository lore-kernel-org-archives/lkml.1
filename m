Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZA1X1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZA1X1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZA1X1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:27:08 -0500
Received: from kroah.org ([198.145.64.141]:56963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbZA1X1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:27:07 -0500
Date: Wed, 28 Jan 2009 15:23:19 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tiny staging patches that fix some build errors and common
Kconfig problems that people have reported.  There are also a few other
minor, "obvious" bugfixes to some of the drivers as well and a
documentation update.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All but one of these have been in the -next releases with no known build
errors.  The one that wasn't was pointed out to me by Randy Dunlap and
fixes a build issue on 64bit boxes that he found.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

--------------

 drivers/staging/agnx/agnx.h                 |    2 ++
 drivers/staging/android/binder.c            |   16 ++++++++--------
 drivers/staging/android/lowmemorykiller.txt |   16 ++++++++++++++++
 drivers/staging/android/timed_gpio.c        |    5 +++--
 drivers/staging/comedi/Kconfig              |    1 +
 drivers/staging/meilhaus/Kconfig            |   21 +++++++++++----------
 drivers/staging/poch/poch.c                 |    2 +-
 drivers/staging/usbip/usbip_common.c        |   16 ++++++++++++++--
 8 files changed, 56 insertions(+), 23 deletions(-)
 create mode 100644 drivers/staging/android/lowmemorykiller.txt

---------------

Arve Hjønnevåg (3):
      Staging: android: binder: fix arm build errors
      Staging: android: timed_gpio: Fix build to build on kernels after 2.6.25.
      Staging: android: Add lowmemorykiller documentation.

Geert Uytterhoeven (1):
      staging: agnx: drivers/staging/agnx/agnx.h needs <linux/io.h>

Greg Kroah-Hartman (3):
      Staging: comedi: fix Kbuild
      Staging: meilhaus: fix Kbuild
      Staging: android: fix build error on 64bit boxes

Oleg Nesterov (1):
      Staging: android: task_get_unused_fd_flags: fix the wrong usage of tsk->signal

Roel Kluin (2):
      Staging: usbip: usbip_start_threads(): handle kernel_thread failure
      Staging: poch: fix verification of memory area


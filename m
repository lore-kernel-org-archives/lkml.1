Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXLQS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXLQS61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbXLQS5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:57:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33778 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbXLQS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:57:40 -0500
Date: Mon, 17 Dec 2007 10:56:54 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core and documentation fixes for 2.6.24-rc5
Message-ID: <20071217185654.GC4330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core documentation and translation updates for
2.6.24-rc5.  We also delete the whole tipar.c driver as the driver
author wants it removed because it is no longer needed anymore at all
(userspace programs work just fine without it.)

Most of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/ABI/testing/sysfs-kernel-uids |   14 +
 Documentation/ja_JP/HOWTO                   |    8 +-
 Documentation/ko_KR/HOWTO                   |  144 ++++----
 Documentation/ko_KR/stable_api_nonsense.txt |  195 ++++++++++
 Documentation/tipar.txt                     |   93 -----
 MAINTAINERS                                 |    5 -
 drivers/char/Kconfig                        |   22 -
 drivers/char/tipar.c                        |  557 ---------------------------
 include/linux/ticable.h                     |   44 ---
 lib/kobject.c                               |   12 +-
 10 files changed, 292 insertions(+), 802 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-uids
 create mode 100644 Documentation/ko_KR/stable_api_nonsense.txt
 delete mode 100644 Documentation/tipar.txt
 delete mode 100644 drivers/char/tipar.c
 delete mode 100644 include/linux/ticable.h

---------------

Dhaval Giani (1):
      Add Documentation for FAIR_USER_SCHED sysfs files

Greg Kroah-Hartman (1):
      kobject: fix the documentation of how kobject_set_name works

Romain Liévin (1):
      tipar: remove obsolete module

Tsugikazu Shibata (1):
      HOWTO: Change man-page maintainer address for Japanese HOWTO

barrios (2):
      add stable_api_nonsense.txt in korean
      HOWTO: update misspelling and word incorrected

minchan kim (1):
      HOWTO: change addresses of maintainer and lxr url for Korean HOWTO


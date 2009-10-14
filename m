Return-Path: <linux-kernel-owner+w=401wt.eu-S934573AbZJNXIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbZJNXIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934527AbZJNXIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:08:34 -0400
Received: from kroah.org ([198.145.64.141]:41607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762107AbZJNXIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:08:09 -0400
Date: Wed, 14 Oct 2009 16:04:37 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.32-git
Message-ID: <20091014230437.GC8865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging fixes for your 2.6.32-git tree.

The majority are build fixes due to the sched.h include change.  The
other fix here is for the et131x driver that was reported by a user.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/b3dfg/b3dfg.c                  |    1 +
 drivers/staging/comedi/drivers/me_daq.c        |    1 +
 drivers/staging/comedi/drivers/ni_mio_common.c |    1 +
 drivers/staging/comedi/drivers/ni_pcidio.c     |    1 +
 drivers/staging/et131x/et1310_address_map.h    |    2 +-
 drivers/staging/et131x/et1310_rx.c             |   20 ++++++++++++++------
 drivers/staging/hv/osd.c                       |    1 +
 drivers/staging/iio/industrialio-core.c        |    2 ++
 drivers/staging/poch/poch.c                    |    1 +
 drivers/staging/rt2860/common/cmm_data_2860.c  |    2 ++
 drivers/staging/rt2860/common/cmm_info.c       |    1 +
 drivers/staging/rt2860/rt_linux.c              |    1 +
 drivers/staging/rt3090/common/cmm_info.c       |    1 +
 drivers/staging/rt3090/rt_linux.c              |    1 +
 drivers/staging/sep/sep_driver.c               |    1 +
 drivers/staging/vme/bridges/vme_ca91cx42.c     |    1 +
 drivers/staging/vme/bridges/vme_tsi148.c       |    1 +
 17 files changed, 32 insertions(+), 7 deletions(-)

---------------

Alan Cox (2):
      Staging: et131x: Correct WRAP bit handling
      Staging: et131x: Fix the add_10bit macro

Darren Salt (1):
      Staging: rt2860sta: prevent a panic when disabling when associated

Greg Kroah-Hartman (4):
      Staging: comedi: fix sched.h build breakage
      Staging: b3dfg: fix sched.h build breakage
      Staging: poch: fix sched.h build breakage
      Staging: vme: fix sched.h build breakage

Jeff Mahoney (2):
      staging: Complete sched.h removal from interrupt.h
      staging: more sched.h fixes

Jonathan Cameron (1):
      Staging: iio: Fix missing include <linux/sched.h>


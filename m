Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFSP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFSP5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZFSP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:57:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25494 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZFSP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:57:03 -0400
Date: Fri, 19 Jun 2009 17:56:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.31, part 2
Message-ID: <20090619175655.4723aef2@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a second set of i2c subsystem updates for Linux 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

The most important part is the removal of the legacy i2c binding model
support, together with all the cleanups it allowed.

 Documentation/feature-removal-schedule.txt |   10 -
 Documentation/i2c/instantiating-devices    |   44 +++
 Documentation/i2c/writing-clients          |   16 +-
 drivers/i2c/i2c-boardinfo.c                |    7 +-
 drivers/i2c/i2c-core.c                     |  557 ++++++++++------------------
 drivers/i2c/i2c-core.h                     |    4 +-
 include/linux/i2c.h                        |   72 ++---
 7 files changed, 275 insertions(+), 435 deletions(-)

---------------

Hans Verkuil (1):
      i2c: New macro to initialize i2c address lists on the fly

Jean Delvare (9):
      i2c: Kill client_register and client_unregister methods
      i2c: Get rid of the legacy binding model
      i2c: Drop i2c_probe function
      i2c: Merge i2c_attach_client into i2c_new_device
      i2c: Kill is_newstyle_driver
      i2c: Kill the redundant client list
      i2c: Limit core locking to the necessary sections
      i2c: Add a sysfs interface to instantiate devices
      i2c: Don't advertise i2c functions when not available

Rodolfo Giometti (1):
      i2c: Use rwsem instead of mutex for board info

Thanks,
-- 
Jean Delvare

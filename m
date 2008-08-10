Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYHJVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYHJVAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYHJVAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:00:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44959 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYHJVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:00:33 -0400
Date: Sun, 10 Aug 2008 22:59:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.27
Message-ID: <20080810225949.280e2527@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 drivers/hwmon/lm75.c                   |  114 ++++++-------------------------
 drivers/i2c/Kconfig                    |   14 ++++
 drivers/i2c/algos/Kconfig              |   11 ++-
 drivers/i2c/busses/i2c-amd756-s4882.c  |    9 +--
 drivers/i2c/busses/i2c-nforce2-s4985.c |    5 +-
 drivers/i2c/chips/at24.c               |    8 +-
 drivers/i2c/i2c-core.c                 |   11 +++-
 drivers/i2c/i2c-dev.c                  |    4 +-
 8 files changed, 66 insertions(+), 110 deletions(-)

---------------

David Brownell (1):
      i2c: correct some size_t printk formats

Hans Verkuil (1):
      i2c: Fix NULL pointer dereference in i2c_new_probed_device

Jean Delvare (4):
      i2c: Fix oops on bus multiplexer driver loading
      i2c: Let users select algorithm drivers manually again
      i2c: Check for address business before creating clients
      hwmon: (lm75) Drop legacy i2c driver


Thanks,
-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYEKTNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYEKTNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYEKTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:12:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3133 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYEKTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:12:57 -0400
Date: Sun, 11 May 2008 21:12:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] More i2c updates for 2.6.26
Message-ID: <20080511211234.11215916@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.26 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

You'll get more pieces of the conversion of the device/driver matching
model of the i2c subsystem, blacklisting of 2 motherboards in the
i2c-piix4 SMBus controller driver for safety reasons, documentation
updates and a few random fixes.

 Documentation/i2c/functionality     |   95 +++++++++++++++++++----------------
 Documentation/i2c/smbus-protocol    |   81 +++++++++++++++++-------------
 drivers/i2c/busses/i2c-mpc.c        |   16 +++---
 drivers/i2c/busses/i2c-piix4.c      |   47 +++++++++++++++--
 drivers/i2c/busses/i2c-sibyte.c     |    6 +-
 drivers/i2c/i2c-core.c              |   14 +++--
 drivers/media/video/tcm825x.c       |    7 +++
 drivers/media/video/tlv320aic23b.c  |    6 ++
 drivers/media/video/tvaudio.c       |   13 ++++-
 drivers/rtc/rtc-s35390a.c           |    2 +-
 include/linux/i2c.h                 |    2 +-
 include/media/v4l2-i2c-drv-legacy.h |    2 +
 include/media/v4l2-i2c-drv.h        |    2 +
 13 files changed, 189 insertions(+), 104 deletions(-)

---------------

David Brownell (1):
      i2c: Improve smbus-protocol documentation

David Milburn (1):
      i2c-piix4: Increase the intitial delay for the ServerWorks CSB5

Jean Delvare (4):
      i2c-piix4: Blacklist two mainboards
      i2c: Improve the functionality documentation
      i2c: Match dummy devices by type
      i2c: Convert some more new-style drivers to use module aliasing

Jon Smirl (1):
      i2c-mpc: Compare to NO_IRQ instead of zero

Maciej W. Rozycki (2):
      i2c-sibyte: Correct a comment about frequency
      i2c-sibyte: Mark i2c_sibyte_add_bus() as static

Thanks,
-- 
Jean Delvare

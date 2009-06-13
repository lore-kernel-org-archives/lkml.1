Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZFMKAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZFMKAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZFMKAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:00:25 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:54283 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbZFMKAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:00:24 -0400
To: apkm@linux-foundation.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' i2c tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1MFQ1x-00050J-Kc@kira.home.fluff.org>
Date: Sat, 13 Jun 2009 11:00:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f3ad116588151b3371ae4e092290e4f48e62b8bb:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/configfs

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git next-i2c

Aaro Koskinen (2):
      i2c: OMAP2/3: Fix scll/sclh calculations
      i2c: OMAP3: Better noise suppression for fast/standard modes

Ben Dooks (1):
      i2c-s3c2410: move to using platform idtable to match devices

Frank Shew (1):
      i2c: Blackfin TWI: fix transfer errors with repeat start

Michael Hennerich (2):
      i2c: Blackfin TWI: make sure we don't end up with a CLKDIV=0
      i2c: Blackfin TWI: implement I2C_FUNC_SMBUS_I2C_BLOCK functionality

Richard Röjfors (1):
      i2c-ocores: Can add I2C devices to the bus

Sonic Zhang (1):
      i2c: Blackfin TWI: fix REPEAT START mode doesn't repeat

 Documentation/i2c/busses/i2c-ocores |   17 ++++++++++
 drivers/i2c/busses/Kconfig          |    2 +-
 drivers/i2c/busses/i2c-bfin-twi.c   |   59 ++++++++++++++++++++++++----------
 drivers/i2c/busses/i2c-ocores.c     |    5 +++
 drivers/i2c/busses/i2c-omap.c       |   39 ++++++++++++++++++-----
 drivers/i2c/busses/i2c-s3c2410.c    |   48 +++++++++++++---------------
 include/linux/i2c-ocores.h          |    2 +
 7 files changed, 118 insertions(+), 54 deletions(-)

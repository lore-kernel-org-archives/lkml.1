Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXKOSvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXKOSvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760572AbXKOSu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:50:57 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4316 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759604AbXKOSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:50:56 -0500
Date: Thu, 15 Nov 2007 19:50:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.24
Message-ID: <20071115195054.1a91df5a@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.24 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There are fixes to the i2c-dev, i2c-pasemi and eeprom drivers, and
comment updates.

 drivers/i2c/busses/i2c-pasemi.c |    7 +++-
 drivers/i2c/chips/eeprom.c      |   37 +++++++++++------
 drivers/i2c/i2c-core.c          |    3 +-
 drivers/i2c/i2c-dev.c           |   86 ++++++++++++++++++++++++++++++++++++++-
 include/linux/i2c.h             |    5 --
 5 files changed, 115 insertions(+), 23 deletions(-)

---------------

David Brownell (1):
      i2c-dev: "how does it work" comments

Jean Delvare (4):
      i2c-dev: Unbound new-style i2c clients aren't busy
      i2c: Make i2c_check_addr static
      i2c/eeprom: Hide Sony Vaio serial numbers
      i2c/eeprom: Recognize VGN as a valid Sony Vaio name prefix

Olof Johansson (1):
      i2c-pasemi: Fix NACK detection

Robert P. J. Day (1):
      i2c-pasemi: Replace obsolete "driverfs" reference with "sysfs"

Thanks,
-- 
Jean Delvare

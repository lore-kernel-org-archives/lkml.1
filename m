Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbZKYMqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbZKYMqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934635AbZKYMqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:46:07 -0500
Received: from bamako.nerim.net ([62.4.17.28]:51652 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934580AbZKYMqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:46:03 -0500
Date: Wed, 25 Nov 2009 13:46:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.32
Message-ID: <20091125134607.5dc83117@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the last i2c subsystem updates for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 MAINTAINERS                 |    3 +-
 drivers/i2c/chips/tsl2550.c |    3 ++
 drivers/i2c/i2c-core.c      |   11 ++++++
 drivers/misc/eeprom/at24.c  |   76 +++++++++++++++++++++++++-----------------
 4 files changed, 60 insertions(+), 33 deletions(-)

---------------

Jean Delvare (2):
      MAINTAINERS: Add missing i2c files
      i2c: Fix userspace_device list corruption

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in extended mode

Wolfram Sang (1):
      at24: Use timeout also for read

Thanks,
-- 
Jean Delvare

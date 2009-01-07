Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZAGNdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZAGNdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZAGNdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:33:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36981 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZAGNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:33:38 -0500
Date: Wed, 7 Jan 2009 14:33:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.29
Message-ID: <20090107143330.4b324026@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem updates for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

Only small changes this time, with the exception of the conversion of
the apanel driver to the standard i2c device driver binding model.

 drivers/i2c/busses/i2c-ali1563.c               |    4 +-
 drivers/i2c/busses/i2c-amd756-s4882.c          |    4 +-
 drivers/i2c/busses/i2c-amd756.c                |    5 +-
 drivers/i2c/busses/i2c-at91.c                  |    2 +-
 drivers/i2c/busses/i2c-bfin-twi.c              |    2 +-
 drivers/i2c/busses/i2c-i801.c                  |   50 ++++++++++++++-
 drivers/i2c/busses/i2c-pxa.c                   |    4 +-
 drivers/i2c/busses/i2c-s3c2410.c               |    2 +-
 drivers/i2c/busses/i2c-sh7760.c                |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c             |    2 +-
 drivers/i2c/busses/i2c-sis5595.c               |    4 +-
 drivers/i2c/busses/i2c-sis630.c                |    4 +-
 drivers/i2c/i2c-core.c                         |    8 +-
 drivers/input/misc/apanel.c                    |   81 ++++++++----------------
 drivers/media/video/cafe_ccic.c                |    1 -
 drivers/media/video/ov7670.c                   |    1 -
 drivers/media/video/ovcamchip/ovcamchip_core.c |    1 -
 drivers/media/video/w9968cf.c                  |    1 -
 include/linux/i2c.h                            |    4 -
 19 files changed, 98 insertions(+), 84 deletions(-)

---------------

Jean Delvare (6):
      i2c: Get rid of remaining bus_id access
      i2c: Drop I2C_CLASS_ALL
      i2c: Drop I2C_CLASS_CAM_ANALOG and I2C_CLASS_SOUND
      i2c: Drop I2C_CLASS_CAM_DIGITAL
      Input: apanel - convert to new i2c binding
      i2c: Use snprintf to set adapter names

Kay Sievers (1):
      i2c: Replace bus_id with dev_name(), dev_set_name()

Thanks,
-- 
Jean Delvare

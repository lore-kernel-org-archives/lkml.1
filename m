Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZDUTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZDUTGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZDUTGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:06:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15532 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZDUTGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:06:09 -0400
Date: Tue, 21 Apr 2009 21:05:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.30
Message-ID: <20090421210557.66bd41f4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.30 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/staging/go7007/go7007-driver.c  |   11 +++-
 drivers/staging/go7007/go7007-i2c.c     |   83 -------------------------------
 drivers/staging/go7007/go7007-priv.h    |    1 +
 drivers/staging/go7007/go7007-usb.c     |   14 ++++-
 drivers/staging/go7007/s2250-board.c    |   71 +++++++++++---------------
 drivers/staging/go7007/wis-i2c.h        |    9 ---
 drivers/staging/go7007/wis-ov7640.c     |   56 ++++++--------------
 drivers/staging/go7007/wis-saa7113.c    |   60 +++++++---------------
 drivers/staging/go7007/wis-saa7115.c    |   60 +++++++---------------
 drivers/staging/go7007/wis-sony-tuner.c |   60 +++++++----------------
 drivers/staging/go7007/wis-tw2804.c     |   57 +++++++--------------
 drivers/staging/go7007/wis-tw9903.c     |   60 +++++++---------------
 drivers/staging/go7007/wis-uda1342.c    |   52 ++++++--------------
 13 files changed, 176 insertions(+), 418 deletions(-)

---------------

Jean Delvare (1):
      go7007: Convert to the new i2c device binding model

Thanks,
-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZEEGtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZEEGtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZEEGtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:49:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12539 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZEEGtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:49:39 -0400
Date: Tue, 5 May 2009 08:49:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: [GIT PULL] i2c fixes for 2.6.30
Message-ID: <20090505084932.3fd1c519@hyperion.delvare>
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

 drivers/i2c/algos/i2c-algo-bit.c |    2 +-
 drivers/i2c/algos/i2c-algo-pca.c |   11 +++++++++++
 drivers/i2c/busses/i2c-ali1535.c |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c |    2 +-
 drivers/i2c/busses/i2c-amd756.c  |    4 ++--
 drivers/i2c/busses/i2c-i801.c    |    8 ++++----
 drivers/i2c/busses/i2c-isch.c    |    2 +-
 drivers/i2c/busses/i2c-nforce2.c |    2 +-
 drivers/i2c/busses/i2c-sis5595.c |    2 +-
 drivers/i2c/busses/i2c-sis630.c  |    2 +-
 drivers/i2c/busses/i2c-sis96x.c  |    2 +-
 11 files changed, 25 insertions(+), 14 deletions(-)

---------------

Dave Airlie (1):
      i2c-algo-bit: Fix timeout test

Enrik Berkhan (1):
      i2c-algo-pca: Let PCA9564 recover from unacked data byte (state 0x30)

Roel Kluin (1):
      i2c: Timeouts off by 1

Thanks,
-- 
Jean Delvare

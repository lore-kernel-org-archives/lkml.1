Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZDFQPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZDFQPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbZDFQPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:15:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42783 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbZDFQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:15:17 -0400
Date: Mon, 6 Apr 2009 18:15:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c cleanups for 2.6.30
Message-ID: <20090406181508.4a372d74@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem cleanups for Linux 2.6.30 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 Documentation/feature-removal-schedule.txt |    3 +-
 drivers/i2c/algos/Kconfig                  |    4 -
 drivers/i2c/algos/Makefile                 |    1 -
 drivers/i2c/algos/i2c-algo-sgi.c           |  179 ----------------------------
 include/linux/i2c-algo-sgi.h               |   26 ----
 include/linux/i2c-id.h                     |   37 ------
 include/linux/i2c.h                        |    4 +-
 7 files changed, 4 insertions(+), 250 deletions(-)
 delete mode 100644 drivers/i2c/algos/i2c-algo-sgi.c
 delete mode 100644 include/linux/i2c-algo-sgi.h

---------------

Jean Delvare (3):
      i2c: Deprecate client_register and client_unregister methods
      i2c: Delete many unused driver IDs
      i2c: Delete unused i2c-algo-sgi helper module

Thanks,
-- 
Jean Delvare

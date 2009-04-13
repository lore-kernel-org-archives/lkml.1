Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZDMPMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZDMPMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZDMPMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:12:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13673 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDMPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:12:40 -0400
Date: Mon, 13 Apr 2009 17:12:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.30
Message-ID: <20090413171230.73078c3e@hyperion.delvare>
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

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/i2c/algos/i2c-algo-pca.c           |    2 +-
 drivers/i2c/busses/Kconfig                 |    6 ++++--
 drivers/i2c/i2c-core.c                     |    3 +--
 include/linux/i2c.h                        |    2 +-
 5 files changed, 16 insertions(+), 6 deletions(-)

---------------

Ben Hutchings (1):
      i2c: Fix sparse warnings for I2C_BOARD_INFO()

Jean Delvare (3):
      i2c-algo-pca: Fix use of uninitialized variable in debug message
      i2c-voodoo3: Deprecate in favor of tdfxfb
      i2c: Let new-style drivers implement attach_adapter

Thanks,
-- 
Jean Delvare

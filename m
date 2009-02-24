Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZBXS00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZBXS00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZBXS0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:26:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46016 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZBXS0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:26:17 -0500
Date: Tue, 24 Feb 2009 19:26:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.29
Message-ID: <20090224192603.687d506c@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 arch/arm/mach-rpc/riscpc.c       |    6 ++++++
 drivers/i2c/busses/i2c-acorn.c   |    5 +++--
 drivers/i2c/busses/i2c-amd8111.c |    4 ++--
 drivers/i2c/busses/i2c-ixp2000.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c     |    2 +-
 drivers/i2c/busses/scx200_i2c.c  |    2 +-
 drivers/i2c/i2c-core.c           |    3 ++-
 drivers/i2c/i2c-dev.c            |    6 +++++-
 include/linux/i2c-dev.h          |    2 +-
 include/linux/i2c.h              |    2 +-
 10 files changed, 23 insertions(+), 11 deletions(-)

---------------

Jean Delvare (2):
      i2c-dev: Clarify the unit of ioctl I2C_TIMEOUT
      i2c: Make sure i2c_algo_bit_data.timeout is HZ-independent

Roel Kluin (2):
      i2c: Fix misplaced parentheses
      i2c: Timeouts reach -1

Russell King (1):
      [ARM] Add i2c_board_info for RiscPC PCF8583

Thanks,
-- 
Jean Delvare

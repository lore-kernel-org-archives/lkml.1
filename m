Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYANVBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYANVBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYANVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:01:42 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:2719 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982AbYANVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:01:41 -0500
Date: Mon, 14 Jan 2008 22:01:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] more i2c fixes for 2.6.24
Message-ID: <20080114220138.65ef803a@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.24 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 drivers/i2c/busses/i2c-at91.c     |    2 +-
 drivers/i2c/busses/i2c-omap.c     |    2 +-
 drivers/i2c/busses/i2c-powermac.c |    2 +-
 drivers/i2c/busses/i2c-sibyte.c   |    7 +++++--
 drivers/i2c/i2c-dev.c             |    2 +-
 include/linux/i2c-id.h            |    4 ++++
 6 files changed, 13 insertions(+), 6 deletions(-)

---------------

Jean Delvare (2):
      i2c: Driver IDs are optional
      i2c-sibyte: Fix an error path

Joe Perches (1):
      i2c: Spelling fixes

Tony Lindgren (1):
      i2c-omap: Fix NULL pointer dereferencing


Thanks,
-- 
Jean Delvare

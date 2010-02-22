Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0BVSKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:10:40 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18794 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0BVSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:10:37 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 00/11] Introduce common hex_to_bin() helper
Date: Mon, 22 Feb 2010 20:08:59 +0200
Message-Id: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 22 Feb 2010 18:10:34.0307 (UTC) FILETIME=[53CBE130:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Hello.

There is set of patches related to hex_to_bin() custom implementations. Many of
them are changed to newly introduced common method.

The idea published early by Harvey Harrison [1], but was given to me by
Alexander Shishkin.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0805.0/0323.html

TODO:
 - apply hex_to_bin() to kgdb code
 - /arch

Andy Shevchenko (11):
  lib: introduce common method to convert hex digits
  drivers: isdn: use new hex_to_bin() method
  drivers: net: optimize hex2bin()
  usb: atm: speedtch: use new hex_to_bin() method
  drivers: net: use new hex_to_bin() method
  drivers: net: use new hex_to_bin() method
  sysctl: don't use own implementation of hex_to_bin()
  staging: rt2860: use new hex_to_bin() method
  fs: ldm: don't use own implementation of hex_to_bin()
  drivers: wireless: use new hex_to_bin() method
  drivers: acpi: don't use own implementation of hex_to_bin()

 drivers/acpi/bus.c                        |    9 +------
 drivers/isdn/gigaset/capi.c               |   13 +----------
 drivers/net/cxgb3/t3_hw.c                 |   16 +++----------
 drivers/net/ps3_gelic_wireless.c          |   12 +++-------
 drivers/net/sb1250-mac.c                  |   32 +---------------------------
 drivers/net/wireless/airo.c               |   15 +++----------
 drivers/staging/rt2860/common/rtmp_init.c |   15 +-----------
 drivers/staging/rt2860/rtmp.h             |    2 -
 drivers/usb/atm/speedtch.c                |    5 +--
 fs/partitions/ldm.c                       |   18 ++++++++--------
 include/linux/kernel.h                    |    2 +
 kernel/sysctl_binary.c                    |    9 ++-----
 lib/hexdump.c                             |   19 +++++++++++++++++
 13 files changed, 54 insertions(+), 113 deletions(-)


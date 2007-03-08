Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXCHG5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXCHG5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXCHG5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:57:46 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52835 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932694AbXCHG5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:57:45 -0500
Date: Thu, 8 Mar 2007 07:57:43 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.43
Message-ID: <20070308065743.GG3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New hwmon drivers since 2.6.16.42 for the following hardware:
- National Semiconductor pc87427
- SMSC lpc47m192 and lpc47m997
- Winbond w83791d


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.42:

Adrian Bunk (3):
      Linux 2.6.16.43-rc1
      fs/bad_inode.c 64bit fix
      Linux 2.6.16.43

Alexey Dobriyan (1):
      [IPV4/IPV6] multicast: Check add_grhead() return value

Charles Spirakis (2):
      HWMON: w83791d: New hardware monitoring driver for the Winbond W83791D
      w83791d: Documentation update

Francois Romieu (1):
      sis190: failure to set the MAC address from EEPROM

Hartmut Rick (1):
      smsc47m192: New hwmon driver for SMSC LPC47M192/997

Ilpo Järvinen (1):
      [TCP]: Prevent pseudo garbage in SYN's advertized window

Jean Delvare (3):
      hwmon: New PC87427 hardware monitoring driver
      hwmon: Add support for the Winbond W83687THF
      i2c-isa: Restore driver owner

Jim Cromie (2):
      hwmon: Allow sensor attributes arrays
      hwmon: Refactor SENSOR_DEVICE_ATTR_2

Jordan Crouse (1):
      hwmon lm83: Add LM82 support

Kirill Korotaev (1):
      fix ext3 block bitmap leakage

Marcel Siegert (1):
      V4L/DVB: Dvbdev: fix illegal re-usage of fileoperations struct

Martin Devera (1):
      I2C: i2c-piix4: Add Broadcom HT-1000 support

Patrick McHardy (1):
      [DECNET]: Fix sfuzz hanging on 2.6.18

Rudolf Marek (1):
      i2c-piix4: Add ATI IXP200/300/400 support

Stephen Hemminger (6):
      sky2: fix ram buffer allocation settings
      sky2: allow multicast pause frames
      sky2: fix for use on big endian
      sky2: more stats
      sky2: add more pci ids
      sky2: email and version change.


 Documentation/hwmon/lm83            |   16 
 Documentation/hwmon/pc87427         |   38 
 Documentation/hwmon/smsc47m192      |  102 ++
 Documentation/hwmon/sysfs-interface |    6 
 Documentation/hwmon/w83627hf        |    4 
 Documentation/hwmon/w83791d         |  120 ++
 Documentation/i2c/busses/i2c-piix4  |    4 
 Makefile                            |    2 
 drivers/hwmon/Kconfig               |   57 +
 drivers/hwmon/Makefile              |    3 
 drivers/hwmon/it87.c                |    1 
 drivers/hwmon/lm78.c                |    1 
 drivers/hwmon/lm83.c                |   50 -
 drivers/hwmon/pc87360.c             |    1 
 drivers/hwmon/pc87427.c             |  627 +++++++++++++
 drivers/hwmon/sis5595.c             |    1 
 drivers/hwmon/smsc47b397.c          |    1 
 drivers/hwmon/smsc47m1.c            |    1 
 drivers/hwmon/smsc47m192.c          |  648 ++++++++++++++
 drivers/hwmon/via686a.c             |    1 
 drivers/hwmon/vt8231.c              |    1 
 drivers/hwmon/w83627ehf.c           |    1 
 drivers/hwmon/w83627hf.c            |   73 +
 drivers/hwmon/w83781d.c             |    1 
 drivers/hwmon/w83791d.c             | 1256 ++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig          |    9 
 drivers/i2c/busses/i2c-piix4.c      |   10 
 drivers/media/dvb/dvb-core/dvbdev.c |   13 
 drivers/net/sis190.c                |    2 
 drivers/net/sky2.c                  |  146 ++-
 fs/bad_inode.c                      |    8 
 fs/ext3/inode.c                     |    1 
 include/linux/hwmon-sysfs.h         |   24 
 include/linux/pci_ids.h             |    4 
 net/decnet/af_decnet.c              |    4 
 net/ipv4/igmp.c                     |    2 
 net/ipv4/tcp_output.c               |    4 
 net/ipv6/mcast.c                    |    2 
 38 files changed, 3130 insertions(+), 115 deletions(-)


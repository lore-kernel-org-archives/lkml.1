Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYJZQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYJZQIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYJZQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:08:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44590 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbYJZQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:08:11 -0400
Date: Sun, 26 Oct 2008 17:07:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.28
Message-ID: <20081026170753.6442a7fc@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.28 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 Documentation/hwmon/lm90   |    2 +-
 drivers/hwmon/abituguru3.c |   30 ++++++++++++------------
 drivers/hwmon/adt7473.c    |   29 +++++++-----------------
 drivers/hwmon/hwmon-vid.c  |    1 +
 drivers/hwmon/lm90.c       |   52 ++++++++++++++++++++++++++++++++++++++------
 drivers/hwmon/w83781d.c    |    4 +-
 6 files changed, 73 insertions(+), 45 deletions(-)

---------------

Alistair John Strachan (2):
      hwmon: (abituguru3) Cosmetic whitespace fixes
      hwmon: (abituguru3) enable DMI probing feature on AW9D-MAX

Geert Uytterhoeven (1):
      hwmon: (w83781d) Fix linking when built-in

Jean Delvare (4):
      hwmon-vid: Add support for AMD family 10h CPUs
      hwmon: (lm90) Fix handling of hysteresis value
      hwmon: (lm90) Add support for the LM99 16 degree offset
      hwmon: (adt7473) Fix voltage conversion routines

Thanks,
-- 
Jean Delvare

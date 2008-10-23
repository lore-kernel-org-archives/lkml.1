Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbYJWVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbYJWVpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYJWVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:45:17 -0400
Received: from mga10.intel.com ([192.55.52.92]:52026 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753948AbYJWVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,472,1220252400"; 
   d="scan'208";a="630978495"
Subject: [GIT PULL] LED updates for 2.6.28
From: Richard Purdie <rpurdie@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 22:45:02 +0100
Message-Id: <1224798302.5427.77.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the led tree updates for 2.6.28. This includes a couple of new LED
drivers, removal of an obsolete one, a new LED trigger and various minor 
tweaks/fixes. These have seen testing in -mm/-next.

Thanks, Richard

 drivers/leds/Kconfig             |   25 ++++-
 drivers/leds/Makefile            |    4 
 drivers/leds/led-class.c         |   12 +-
 drivers/leds/leds-ams-delta.c    |   20 ++--
 drivers/leds/leds-cm-x270.c      |  124 ---------------------------
 drivers/leds/leds-da903x.c       |  175 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-hp-disk.c      |  156 ++++++++++++++++++++++++++++++++++
 drivers/leds/leds-pca955x.c      |    2 
 drivers/leds/leds-wrap.c         |    5 -
 drivers/leds/ledtrig-backlight.c |  110 ++++++++++++++++++++++++
 drivers/leds/ledtrig-timer.c     |    8 -
 include/linux/leds.h             |    4 
 12 files changed, 488 insertions(+), 157 deletions(-)

Mike Rapoport (1):
      leds: da903x: Add support for LEDs found on DA9030/DA9034

Pavel Machek (1):
      leds: Add driver for HP harddisk protection LEDs

Qinghuang Feng (1):
      leds: Fix leds-class.c comment

Richard Purdie (3):
      leds: Remove uneeded leds-cm-x270 driver
      leds: Fix trigger registration race
      leds: Simplify logic in leds-ams-delta

Rodolfo Giometti (1):
      leds: Add backlight LED trigger

Stephen Rothwell (1):
      leds/acpi: Fix merge fallout from acpi_driver_data change

Sven Wegener (3):
      leds: Add leds-wrap default-trigger
      leds: Remove uneeded strlen calls
      leds: leds-pca955x - Mark pca955x_led_set() static

Trent Piepho (1):
      leds: Make default trigger fields const



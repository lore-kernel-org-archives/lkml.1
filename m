Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbXGRF1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbXGRF1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXGRF1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:27:05 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:45330 "EHLO
	asav14.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXGRF1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:27:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAERBnUZKhRO4Rmdsb2JhbACPOQEBARYNBgw
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] More input updates for post-2.6.22
Date: Wed, 18 Jul 2007 01:27:00 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180127.01614.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or

	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
---------

Dmitry Torokhov (3):
      Input: add driver for Fujitsu serial touchscreens
      Input: i8042 - give more trust to PNP data on i386
      Input: document intended meaning of KEY_SWITCHVIDEOMODE

Jan Kratochvil (1):
      Input: xpad - add support for leds on xbox 360 pad

Pavel Emelianov (1):
      Input: switch to using seq_list_xxx helpers

Semih Hazar (2):
      Input: ads7846 - introduce sample settling delay
      Input: ads7846 - re-check pendown status before reporting events

Diffstat:
--------

 drivers/input/input.c                  |   29 +----
 drivers/input/joystick/Kconfig         |    7 +
 drivers/input/joystick/xpad.c          |  190 +++++++++++++++++++++++++-------
 drivers/input/serio/i8042-x86ia64io.h  |   36 +++++-
 drivers/input/touchscreen/Kconfig      |   13 ++
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/ads7846.c    |   80 +++++++++++++-
 drivers/input/touchscreen/fujitsu_ts.c |  189 +++++++++++++++++++++++++++++++
 include/linux/input.h                  |    3 +-
 include/linux/serio.h                  |    1 +
 include/linux/spi/ads7846.h            |   14 +++
 11 files changed, 487 insertions(+), 76 deletions(-)
 create mode 100644 drivers/input/touchscreen/fujitsu_ts.c

-- 
Dmitry

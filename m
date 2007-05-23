Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXEWEJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXEWEJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEWEI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:08:57 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:23933 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbXEWEI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:08:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRADhbU0ZKhRO4W2dsb2JhbACHQYhGHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates ofr 2.6.22-rc2
Date: Wed, 23 May 2007 00:08:46 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705230008.47803.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem. You will get bugfixes for ALPS
touchpad, iforce force feedback support, ads7846 touchscreen and several
small cleanups.

Changelog:
----------

David Brownell (1):
      Input: ads7846 - document that it handles tsc2046 too

Dmitry Torokhov (3):
      Input: adbhid - do not access input_dev->private directly
      Input: ALPS - force stream mode
      Input: ucb1x00-ts - remove commented out code

Eric Piel (1):
      Input: input-polldev - add module info

Johann Deneux (2):
      Input: iforce - fix force feedback not working
      Input: iforce - minor clean-ups

Peter Samuelson (1):
      Input: logips2pp - add type 72 (PS/2 TrackMan Marble)

Satoru Takeuchi (1):
      Input: ucb1400_ts - use sched_setscheduler()

Semih Hazar (1):
      Input: ads7846 - SPI_CPHA mode bugfix

 drivers/input/joystick/iforce/iforce-main.c    |    4 +-
 drivers/input/joystick/iforce/iforce-packets.c |   10 +++-
 drivers/input/joystick/iforce/iforce-usb.c     |    5 +-
 drivers/input/misc/input-polldev.c             |    5 ++
 drivers/input/mouse/alps.c                     |   58 +++++++++++++-----------
 drivers/input/mouse/logips2pp.c                |    1 +
 drivers/input/touchscreen/Kconfig              |    8 ++--
 drivers/input/touchscreen/ads7846.c            |    3 +-
 drivers/input/touchscreen/ucb1400_ts.c         |    4 +-
 drivers/macintosh/adbhid.c                     |   16 +++---
 drivers/mfd/ucb1x00-ts.c                       |   11 +----
 11 files changed, 66 insertions(+), 59 deletions(-)


-- 
Dmitry

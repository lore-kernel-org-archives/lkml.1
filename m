Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0BBHON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:14:13 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:51405 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0BBHOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:14:09 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 0/5] Implements a common PWM API
Date: Tue,  2 Feb 2010 01:14:51 -0600
Message-Id: <cover.1265094517.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements a common PWM API.  This series incorporates
the feedback from the linux-embedded mailing list and elsewhere; the author
greatly appreciates the efforts of everyone who reviewed the previous version
of this code.

Bill Gatliff (5):
  API to consolidate PWM devices behind a common user and kernel
    interface
  Emulates PWM hardware using a high-resolution timer and a GPIO pin
  Expunge old Atmel PWMC driver, replacing it with one that conforms to
    the PWM API
  PWM-based LED control
  LED "dimmer" trigger

 Documentation/pwm.txt       |  260 ++++++++++++++++++
 drivers/leds/leds-pwm.c     |  224 +++++++++-------
 drivers/leds/ledtrig-dim.c  |   95 +++++++
 drivers/misc/Makefile       |    6 +-
 drivers/misc/atmel_pwm.c    |  409 ----------------------------
 drivers/pwm/atmel-pwm.c     |  589 ++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/gpio.c          |  307 +++++++++++++++++++++
 drivers/pwm/pwm.c           |  633 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h         |   31 --
 include/linux/pwm/pwm-led.h |   34 +++
 include/linux/pwm/pwm.h     |  170 ++++++++++++
 11 files changed, 2217 insertions(+), 541 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/leds/ledtrig-dim.c
 delete mode 100644 drivers/misc/atmel_pwm.c
 create mode 100644 drivers/pwm/atmel-pwm.c
 create mode 100644 drivers/pwm/gpio.c
 create mode 100644 drivers/pwm/pwm.c
 delete mode 100644 include/linux/pwm.h
 create mode 100644 include/linux/pwm/pwm-led.h
 create mode 100644 include/linux/pwm/pwm.h


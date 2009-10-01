Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZJAKGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZJAKGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZJAKGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:06:35 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41835 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZJAKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:06:34 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RFC][PATCH 0/2] LIS3LV02D I2C driver
Date: Thu,  1 Oct 2009 13:06:29 +0300
Message-Id: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 01 Oct 2009 10:06:32.0625 (UTC) FILETIME=[DA1EE210:01CA427E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add I2C bus support for LIS3LV02D accelerometer driver
and possibility to use platform configurability for
remapping of device axes.

Changes are tested on linux-omap environment.
Applies to 2.6.32-rc1.

Samu Onkalo (2):
  LIS3LV02D: axis remap, irq and resource setup / release added to
    platform data
  LIS3LV02D: I2C support

 drivers/hwmon/Kconfig         |   17 ++++
 drivers/hwmon/Makefile        |    1 +
 drivers/hwmon/lis3lv02d.h     |    1 +
 drivers/hwmon/lis3lv02d_i2c.c |  183 +++++++++++++++++++++++++++++++++++++++++
 include/linux/lis3lv02d.h     |   13 +++
 5 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/lis3lv02d_i2c.c


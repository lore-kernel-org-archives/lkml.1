Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730Ab0AFJvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0AFJvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607Ab0AFJvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:51:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34691 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab0AFJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:51:20 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH v3 0/4] i2c: davinci: Add power management features
Date: Wed,  6 Jan 2010 14:54:56 +0530
Message-Id: <1262769900-2710-1-git-send-email-chaithrika@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume and cpufreq features to DaVinci I2C driver
All patches apply to Linus' kernel tree.
Testing of these features was done on DA850/OMAP-L138 EVM.

Chaithrika U S (4):
  i2c: davinci: Remove MOD_REG_BIT and IO_ADDRESS usage
  i2c: davinci: Add helper functions
  i2c: davinci: Add suspend/resume support
  i2c: davinci: Add cpufreq support

 drivers/i2c/busses/i2c-davinci.c |  228 ++++++++++++++++++++++++++++---------
 1 files changed, 172 insertions(+), 56 deletions(-)

In this version, the suspend/resume support patch has been updated to
use dev_pm_ops.

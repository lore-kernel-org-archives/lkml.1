Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZHTNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZHTNus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZHTNup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:50:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36750 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZHTNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:50:43 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, tony@atomide.com,
       linux-i2c@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCHv2 0/3] Adding TI TPS PMICs support in the regulator framework
Date: Thu, 20 Aug 2009 19:20:11 +0530
Message-Id: <1250776211-27797-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for TI TPS65023 and TPS6507x PMICs in the voltage
regulator framework. The patches also take care of the comments received
earlier.

Anuj Aggarwal (3):
  Regulator: Add TPS65023 regulator driver
  Regulator: Add TPS6507x regulator driver
  Regulator: Adding TPS65023 and TPS6507x in Kconfig and Makefile

 drivers/regulator/Kconfig              |   16 +
 drivers/regulator/Makefile             |    3 +
 drivers/regulator/tps65023-regulator.c |  631 ++++++++++++++++++++++++++++
 drivers/regulator/tps6507x-regulator.c |  713 ++++++++++++++++++++++++++++++++
 4 files changed, 1363 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps65023-regulator.c
 create mode 100644 drivers/regulator/tps6507x-regulator.c


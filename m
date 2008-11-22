Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYKVA1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYKVA1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKVA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:27:39 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18914 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKVA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:27:39 -0500
Message-ID: <492751CE.4010308@oracle.com>
Date: Fri, 21 Nov 2008 16:26:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] i2o: remove extraneous kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.492751D0.008A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc function parameter notation from i2o/.

Warning(drivers/message/i2o/iop.c:64): Excess function parameter 'msg' description in 'i2o_msg_get_wait'
Warning(drivers/message/i2o/device.c:62): Excess function parameter 'drv' description in 'i2o_device_claim'
Warning(drivers/message/i2o/device.c:95): Excess function parameter 'drv' description in 'i2o_device_claim_release'
Warning(drivers/message/i2o/driver.c:186): Excess function parameter 'msg' description in 'i2o_driver_dispatch'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/i2o/device.c |    2 --
 drivers/message/i2o/driver.c |    1 -
 drivers/message/i2o/iop.c    |    1 -
 3 files changed, 4 deletions(-)

--- linux-2.6.28-rc6-git1.orig/drivers/message/i2o/device.c
+++ linux-2.6.28-rc6-git1/drivers/message/i2o/device.c
@@ -52,7 +52,6 @@ static inline int i2o_device_issue_claim
 /**
  *	i2o_device_claim - claim a device for use by an OSM
  *	@dev: I2O device to claim
- *	@drv: I2O driver which wants to claim the device
  *
  *	Do the leg work to assign a device to a given OSM. If the claim succeeds,
  *	the owner is the primary. If the attempt fails a negative errno code
@@ -80,7 +79,6 @@ int i2o_device_claim(struct i2o_device *
 /**
  *	i2o_device_claim_release - release a device that the OSM is using
  *	@dev: device to release
- *	@drv: driver which claimed the device
  *
  *	Drop a claim by an OSM on a given I2O device.
  *
--- linux-2.6.28-rc6-git1.orig/drivers/message/i2o/driver.c
+++ linux-2.6.28-rc6-git1/drivers/message/i2o/driver.c
@@ -173,7 +173,6 @@ void i2o_driver_unregister(struct i2o_dr
  *	i2o_driver_dispatch - dispatch an I2O reply message
  *	@c: I2O controller of the message
  *	@m: I2O message number
- *	@msg: I2O message to be delivered
  *
  *	The reply is delivered to the driver from which the original message
  *	was. This function is only called from interrupt context.
--- linux-2.6.28-rc6-git1.orig/drivers/message/i2o/iop.c
+++ linux-2.6.28-rc6-git1/drivers/message/i2o/iop.c
@@ -49,7 +49,6 @@ static int i2o_hrt_get(struct i2o_contro
 /**
  *	i2o_msg_get_wait - obtain an I2O message from the IOP
  *	@c: I2O controller
- *	@msg: pointer to a I2O message pointer
  *	@wait: how long to wait until timeout
  *
  *	This function waits up to wait seconds for a message slot to be

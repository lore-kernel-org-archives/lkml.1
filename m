Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbZHVSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbZHVSex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933130AbZHVSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:34:52 -0400
Received: from server1.wserver.cz ([82.113.45.157]:39662 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbZHVSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:34:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: khali@linux-fr.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] I2C: i2c-core, make attr groups const
Date: Sat, 22 Aug 2009 20:34:52 +0200
Message-Id: <1250966092-28291-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make attribute_group structure const, to avoid a compiler warning.

The groups were introduces by commit:
i2c: Convert i2c adapters to bus devices

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/i2c-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index eeb9ae5..8d80fce 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -214,7 +214,7 @@ static struct attribute_group i2c_dev_attr_group = {
 	.attrs		= i2c_dev_attrs,
 };
 
-static struct attribute_group *i2c_dev_attr_groups[] = {
+static const struct attribute_group *i2c_dev_attr_groups[] = {
 	&i2c_dev_attr_group,
 	NULL
 };
@@ -528,7 +528,7 @@ static struct attribute_group i2c_adapter_attr_group = {
 	.attrs		= i2c_adapter_attrs,
 };
 
-static struct attribute_group *i2c_adapter_attr_groups[] = {
+static const struct attribute_group *i2c_adapter_attr_groups[] = {
 	&i2c_adapter_attr_group,
 	NULL
 };
-- 
1.6.3.3


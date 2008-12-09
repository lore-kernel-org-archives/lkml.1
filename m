Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYLISlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYLISlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYLISlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:41:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:58784 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYLISlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZiOCRj7R26zPZf6STjm7i8D6FQJSIoN4yOLL9z4awip8t6vtzdavAQ+egeQRwoEW1q
         tOcPy2QmIMKTlKDbVRwokxkIIVnAjDju+FhL8rHsRodOZD3kXEoM/EnsFs17p7AhAVRg
         Crz4bXfjqvOsyxhVYhbgDLdB/nIwqTdvohSX8=
Message-ID: <493EBBD0.6070201@gmail.com>
Date: Tue, 09 Dec 2008 19:41:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/33] i2c: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/i2c/i2c-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index c6a63f4..1049615 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1699,7 +1699,8 @@ EXPORT_SYMBOL(i2c_smbus_write_word_data);
  * This executes the SMBus "process call" protocol, returning negative errno
  * else a 16-bit unsigned "word" received from the device.
  */
-s32 i2c_smbus_process_call(struct i2c_client *client, u8 command, u16 value)
+static s32 i2c_smbus_process_call(struct i2c_client *client, u8 command,
+		u16 value)
 {
 	union i2c_smbus_data data;
 	int status;

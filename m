Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817Ab0ANWwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0ANWwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261Ab0ANWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:52:06 -0500
Received: from kroah.org ([198.145.64.141]:58169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0ANWwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:06 2010
Message-Id: <20100114224806.492063117@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roger Blofeld <blofeldus@yahoo.com>, Jean Delvare <khali@linux-fr.org>
Subject: [2/9] hwmon: (adt7462) Fix pin 28 monitoring
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roger Blofeld <blofeldus@yahoo.com>

commit bb595c923bc51dff9cdd112de18deb57ac7945d2 upstream.

The ADT7462_PIN28_VOLT value is a 4-bit field, so the corresponding
shift must be 4.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/adt7462.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -97,7 +97,7 @@ I2C_CLIENT_INSMOD_1(adt7462);
 #define		ADT7462_PIN24_SHIFT		6
 #define		ADT7462_PIN26_VOLT_INPUT	0x08
 #define		ADT7462_PIN25_VOLT_INPUT	0x20
-#define		ADT7462_PIN28_SHIFT		6	/* cfg3 */
+#define		ADT7462_PIN28_SHIFT		4	/* cfg3 */
 #define		ADT7462_PIN28_VOLT		0x5
 
 #define ADT7462_REG_ALARM1			0xB8



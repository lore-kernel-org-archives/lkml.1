Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbZCNArY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbZCNArY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZCNAT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:57 -0400
Received: from kroah.org ([198.145.64.141]:35017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbZCNATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000751.351388146@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 81/96] i2c: Fix misplaced parentheses
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=i2c-fix-misplaced-parentheses.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit f29d2e0275a4f03ef2fd158e484508dcb0c64efb upstream

Fix misplaced parentheses.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/i2c/i2c-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1795,7 +1795,8 @@ static s32 i2c_smbus_xfer_emulated(struc
 	case I2C_SMBUS_QUICK:
 		msg[0].len = 0;
 		/* Special case: The read/write field is used as data */
-		msg[0].flags = flags | (read_write==I2C_SMBUS_READ)?I2C_M_RD:0;
+		msg[0].flags = flags | (read_write == I2C_SMBUS_READ ?
+					I2C_M_RD : 0);
 		num = 1;
 		break;
 	case I2C_SMBUS_BYTE:



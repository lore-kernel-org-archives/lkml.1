Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXLBNK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXLBNK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXLBNKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:10:48 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:34899 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbXLBNKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:10:47 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 4/5] net/bonding: Adhere to coding style: break line after the if condition
References: <87wss3jin5.fsf@szonett.ki.iif.hu>
	<871wabkxcd.fsf@szonett.ki.iif.hu>
	<20071127194929.757e4ebe.randy.dunlap@oracle.com>
	<87bq9ekb8m.fsf@szonett.ki.iif.hu> <474D8B83.9050609@oracle.com>
	<87wss1c3d8.fsf_-_@szonett.ki.iif.hu> <26966.1196298795@death>
Date: Sun, 02 Dec 2007 14:10:34 +0100
In-Reply-To: <26966.1196298795@death> (Jay Vosburgh's message of "Wed, 28 Nov
	2007 17:13:15 -0800, Wed, 28 Nov 2007 17:01:23 -0800")
Message-ID: <87mystz1h1.fsf_-_@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/net/bonding/bond_sysfs.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 5c31f5c..9de2c52 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -91,7 +91,8 @@ static ssize_t bonding_show_bonds(struct class *cls, char *buf)
 		}
 		res += sprintf(buf + res, "%s ", bond->dev->name);
 	}
-	if (res) buf[res-1] = '\n'; /* eat the leftover space */
+	if (res)
+		buf[res-1] = '\n'; /* eat the leftover space */
 	up_read(&(bonding_rwsem));
 	return res;
 }
@@ -239,7 +240,8 @@ static ssize_t bonding_show_slaves(struct device *d,
 		res += sprintf(buf + res, "%s ", slave->dev->name);
 	}
 	read_unlock(&bond->lock);
-	if (res) buf[res-1] = '\n'; /* eat the leftover space */
+	if (res)
+		buf[res-1] = '\n'; /* eat the leftover space */
 	return res;
 }
 
@@ -705,7 +707,8 @@ static ssize_t bonding_show_arp_targets(struct device *d,
 			res += sprintf(buf + res, "%u.%u.%u.%u ",
 			       NIPQUAD(bond->params.arp_targets[i]));
 	}
-	if (res) buf[res-1] = '\n'; /* eat the leftover space */
+	if (res)
+		buf[res-1] = '\n'; /* eat the leftover space */
 	return res;
 }
 
-- 
1.4.4.4


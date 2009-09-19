Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZISCqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZISCqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZISCqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:46:49 -0400
Received: from [65.98.92.6] ([65.98.92.6]:1702 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbZISCqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:46:49 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Date: Fri, 18 Sep 2009 19:36:42 -0700
Subject: [PATCH] m25p80: Add Spansion S25FL129P serial flashes
Message-Id: <d26cea5fc295b4eed9273bafeb09c1ae@localhost>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested 64KB block size only.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/devices/m25p80.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 6d8d265..50c5198 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -514,8 +514,10 @@ static struct flash_info __devinitdata m25p_data [] = {
 	{ "s25sl016a", 0x010214, 0, 64 * 1024, 32, },
 	{ "s25sl032a", 0x010215, 0, 64 * 1024, 64, },
 	{ "s25sl064a", 0x010216, 0, 64 * 1024, 128, },
-        { "s25sl12800", 0x012018, 0x0300, 256 * 1024, 64, },
+	{ "s25sl12800", 0x012018, 0x0300, 256 * 1024, 64, },
 	{ "s25sl12801", 0x012018, 0x0301, 64 * 1024, 256, },
+	{ "s25fl129p0", 0x012018, 0x4d00, 256 * 1024, 64, },
+	{ "s25fl129p1", 0x012018, 0x4d01, 64 * 1024, 256, },
 
 	/* SST -- large erase sizes are "overlays", "sectors" are 4K */
 	{ "sst25vf040b", 0xbf258d, 0, 64 * 1024, 8, SECT_4K, },
-- 
1.6.3.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYLEKWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYLEKWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYLEKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:56 -0500
Received: from vps1.tull.net ([66.180.172.116]:47100 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752030AbYLEKUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:54 -0500
Mail-From: nobody Fri Dec  5 14:08:01 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in i2o_block.c
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Nick Andrew <nick@nick-andrew.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:01 +1100
Message-ID: <20081205030801.32014.92677.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in i2o_block.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/message/i2o/i2o_block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 84bdc2e..a443e13 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -354,7 +354,7 @@ static inline void i2o_block_sglist_free(struct i2o_block_request *ireq)
  *	@req: the request to prepare
  *
  *	Allocate the necessary i2o_block_request struct and connect it to
- *	the request. This is needed that we not loose the SG list later on.
+ *	the request. This is needed that we not lose the SG list later on.
  *
  *	Returns BLKPREP_OK on success or BLKPREP_DEFER on failure.
  */



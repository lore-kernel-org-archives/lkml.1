Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYLVT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYLVT0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYLVTW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:22:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:30360 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbYLVTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:22:56 -0500
Subject: [PATCH 09/27] drivers/net/e1000e: fix sparse warnings: make symbols
	static
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:16:13 +0100
Message-ID: <20081222191613.11807.47997.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/net/e1000e/es2lan.c:1265:5: warning: symbol 'e1000_read_kmrn_reg_80003es2lan' was not declared. Should it be static?
  drivers/net/e1000e/es2lan.c:1298:5: warning: symbol 'e1000_write_kmrn_reg_80003es2lan' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/e1000e/es2lan.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
index db51114..8964838 100644
--- a/drivers/net/e1000e/es2lan.c
+++ b/drivers/net/e1000e/es2lan.c
@@ -1262,7 +1262,8 @@ static s32 e1000_cfg_kmrn_1000_80003es2lan(struct e1000_hw *hw)
  *  using the kumeran interface.  The information retrieved is stored in data.
  *  Release the semaphore before exiting.
  **/
-s32 e1000_read_kmrn_reg_80003es2lan(struct e1000_hw *hw, u32 offset, u16 *data)
+static s32 e1000_read_kmrn_reg_80003es2lan(struct e1000_hw *hw, u32 offset,
+					   u16 *data)
 {
 	u32 kmrnctrlsta;
 	s32 ret_val = 0;
@@ -1295,7 +1296,8 @@ s32 e1000_read_kmrn_reg_80003es2lan(struct e1000_hw *hw, u32 offset, u16 *data)
  *  at the offset using the kumeran interface.  Release semaphore
  *  before exiting.
  **/
-s32 e1000_write_kmrn_reg_80003es2lan(struct e1000_hw *hw, u32 offset, u16 data)
+static s32 e1000_write_kmrn_reg_80003es2lan(struct e1000_hw *hw, u32 offset,
+					    u16 data)
 {
 	u32 kmrnctrlsta;
 	s32 ret_val = 0;


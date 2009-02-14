Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZBNVct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZBNVct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBNVcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:32:41 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:33329 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZBNVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:32:40 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 18/43] drivers/net/e1000e: fix sparse warning: Should it be
	static?
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:32:25 +0100
Message-ID: <20090214213152.24377.68475.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Make symbol static.

Fix this sparse warning:
  drivers/net/e1000e/82571.c:1229:5: warning: symbol 'e1000_check_for_serdes_link_82571' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/e1000e/82571.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index 565fd4e..51f8e84 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1226,7 +1226,7 @@ static s32 e1000_setup_fiber_serdes_link_82571(struct e1000_hw *hw)
  *  Checks for link up on the hardware.  If link is not up and we have
  *  a signal, then we need to force link up.
  **/
-s32 e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
+static s32 e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 {
 	struct e1000_mac_info *mac = &hw->mac;
 	u32 rxcw;


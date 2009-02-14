Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZBNVjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZBNVjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZBNViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:38:46 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44740 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZBNVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:38:45 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 24/43] drivers/net/ixgbe: fix sparse warning: Should it be
	static?
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:38:36 +0100
Message-ID: <20090214213822.24377.64757.stgit@vmbox.hanneseder.net>
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
  drivers/net/ixgbe/ixgbe_82598.c:59:5: warning: symbol 'ixgbe_get_pcie_msix_count_82598' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/ixgbe/ixgbe_82598.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_82598.c b/drivers/net/ixgbe/ixgbe_82598.c
index 525bd87..51dba1c 100644
--- a/drivers/net/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ixgbe/ixgbe_82598.c
@@ -56,7 +56,7 @@ static s32 ixgbe_read_i2c_eeprom_82598(struct ixgbe_hw *hw, u8 byte_offset,
  *  Read PCIe configuration space, and get the MSI-X vector count from
  *  the capabilities table.
  **/
-u16 ixgbe_get_pcie_msix_count_82598(struct ixgbe_hw *hw)
+static u16 ixgbe_get_pcie_msix_count_82598(struct ixgbe_hw *hw)
 {
 	struct ixgbe_adapter *adapter = hw->back;
 	u16 msix_count;


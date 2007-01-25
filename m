Return-Path: <linux-kernel-owner+w=401wt.eu-S965244AbXAYEyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244AbXAYEyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXAYEyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:54:49 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:56433 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXAYEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:54:48 -0500
Date: Thu, 25 Jan 2007 05:47:57 +0100
Message-Id: <200701250447.l0P4lvNX016943@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: dbrownell@users.sourceforge.net
CC: mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: 5 patches: updates to SPI and mmc_spi, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, I'm not subscribed to LKML.  Thanks.)

Five SPI-related patches follow.

1: bugfix for spi_bitbang: always call the setup_transfer
function via the overridable pointer.

2: Allow clocking SPI with chip-select inactive.

3: Define the bit-value transmitted for SPI transfers with no tx_buf.

4: Update of David B.'s (et al) kind-of-proof-of-concept
MMC <-> SPI glue driver mmc_spi posted on Aug 1, found at e.g.
<URL:http://www.gossamer-threads.com/lists/linux/kernel/671939#671939>.

5: SPI cleanup should not have const on its argument.

All patches are based on 2.6.19 (sorry, not based on the new MMC
framework).

brgds, H-P

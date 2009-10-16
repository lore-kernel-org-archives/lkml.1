Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbZJPNhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbZJPNhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZJPNhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:37:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53218 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZJPNhE (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 16 Oct 2009 09:37:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] net: vbus-enet fixes
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Fri, 16 Oct 2009 09:36:13 -0400
Message-ID: <20091016133411.13423.36106.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following apply to the linux-next branch for AlacrityVM:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2.6.git

The series fixes a few problems discovered via community feedback and
lockdep.  Please see the patch headers for more details.

Kind Regards,
-Greg

---

Gregory Haskins (2):
      venet: fix locking issue with dev_kfree_skb()
      net: fix vbus-enet Kconfig dependencies


 drivers/net/Kconfig     |    2 +
 drivers/net/vbus-enet.c |   71 +++++++++++++++++++++++------------------------
 2 files changed, 36 insertions(+), 37 deletions(-)

-- 
Signature

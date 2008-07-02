Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYGBU15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYGBU15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYGBU0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:26:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbYGBU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:26:47 -0400
Date: Wed, 2 Jul 2008 13:24:53 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: [patch 03/04] 3c59x: handle pci_name() being const
Message-ID: <20080702202453.GC14024@kroah.com>
References: <20080702200902.909349505@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="3c59x-handle-pci_name-being-const.patch"
In-Reply-To: <20080702202200.GA14021@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes vortex_prob1() to handle pci_name() now returning a
constant string.

Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1010,7 +1010,7 @@ static int __devinit vortex_probe1(struc
 	static int printed_version;
 	int retval, print_info;
 	struct vortex_chip_info * const vci = &vortex_info_tbl[chip_idx];
-	char *print_name = "3c59x";
+	const char *print_name = "3c59x";
 	struct pci_dev *pdev = NULL;
 	struct eisa_device *edev = NULL;
 	DECLARE_MAC_BUF(mac);

-- 

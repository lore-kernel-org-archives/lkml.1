Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbYGVFrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbYGVFrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYGVF1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:27:04 -0400
Received: from mail.suse.de ([195.135.220.2]:54209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbYGVF1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:27:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Subject: [PATCH 77/79] 3c59x: handle pci_name() being const
Date: Mon, 21 Jul 2008 22:19:41 -0700
Message-Id: <1216703983-21448-77-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes vortex_prob1() to handle pci_name() now returning a
constant string.

Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/3c59x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index aabad8c..8db4e6b 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1010,7 +1010,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 	static int printed_version;
 	int retval, print_info;
 	struct vortex_chip_info * const vci = &vortex_info_tbl[chip_idx];
-	char *print_name = "3c59x";
+	const char *print_name = "3c59x";
 	struct pci_dev *pdev = NULL;
 	struct eisa_device *edev = NULL;
 	DECLARE_MAC_BUF(mac);
-- 
1.5.6.3


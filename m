Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYKVRlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYKVRlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYKVRhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:37:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251AbYKVRhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:37:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 24/32] pci_setup() is init, not devinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wPy-0006b4-Lw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:37:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for fsck sake, it's used only when parsing kernel command line...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2042,7 +2042,7 @@ static int __devinit pci_init(void)
 	return 0;
 }
 
-static int __devinit pci_setup(char *str)
+static int __init pci_setup(char *str)
 {
 	while (str) {
 		char *k = strchr(str, ',');

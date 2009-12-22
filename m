Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZLVJGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZLVJGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 04:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZLVJGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 04:06:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:41824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750937AbZLVJGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 04:06:03 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+2L3Ie7Pq2T12lizbQYjmgq+smCIjiW5yL4TJ2Ni
	TUnOZkXFEtapEw
From: Peter Huewe <peterhuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Fix entry for uwb to include subdirectories
Date: Tue, 22 Dec 2009 10:05:58 +0100
Message-Id: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little patch removes the asterisk wildcard, in order to get the uwb
maintainer when using get_maintainer.pl on anyfiles in the
subdirectories of uwb.
Otherwise it get_maintainer.pl does not come up with a result

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e770069..fbcc8f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5467,7 +5467,7 @@ ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 M:	David Vrabel <david.vrabel@csr.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
-F:	drivers/uwb/*
+F:	drivers/uwb/
 F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
-- 
1.6.4.4


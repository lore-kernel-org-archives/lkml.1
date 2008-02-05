Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYBESNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYBESNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYBESNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:13:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:42163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756580AbYBESNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:13:10 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1/yjyMj7tLyTxcUGihgtBDZUTrzFwEdkDtT74dGlV
	aq9l5Lp5uWMjcs
Subject: [PATCH] vitio: Add missing #include <linux/delay.h>
From: Johann Felix Soden <johfel@gmx.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 Feb 2008 19:13:03 +0100
Message-Id: <1202235183.9289.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

Include linux/delay.h to fix compiler error:

drivers/virtio/virtio_balloon.c: In function 'fill_balloon':
drivers/virtio/virtio_balloon.c:98: error: implicit declaration of function 'msleep'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 drivers/virtio/virtio_balloon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 622aece..c8a4332 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 struct virtio_balloon
 {
-- 
1.5.4




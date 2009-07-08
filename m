Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZGHQFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZGHQFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZGHQEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbZGHQEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:06 -0400
Subject: [PATCH 27/44] includecheck fix: drivers/scsi, libfcoe.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       scsi <linux-scsi@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:58:56 +0530
Message-Id: <1247066936.4382.76.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/scsi/fcoe/libfcoe.c: linux/netdevice.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/fcoe/libfcoe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f544340..c7d8ca4 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -29,7 +29,6 @@
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/bitops.h>
 #include <net/rtnetlink.h>
-- 
1.6.0.6




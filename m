Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYKKSZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYKKSZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYKKSZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:25:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:25194 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYKKSZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FJ7M9aQ5HxA43MIoOLniYr2DEHOZavDnjnyhSOf6eITP2idPl2xdiBEUxJCjr7cRhs
         w6h0baItyNYHGCBwlkFa4C/Qocsa5q4ABVhSYYhYIoirGeePmggzqe/5Pmdixkj8I6ds
         7jO6YL35lSZH/Mral7dzV76SoSalURiJI7kk8=
Message-ID: <9d133f60811111025x52e0fcffif5d624ad43cd1173@mail.gmail.com>
Date: Tue, 11 Nov 2008 19:25:18 +0100
From: "Thomas De Schampheleire" <patrickdepinguin@gmail.com>
To: linux-kernel@vger.kernel.org,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Subject: [PATCH] drivers/firmware/memmap.c: fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:
  CHECK   drivers/firmware/memmap.c
  drivers/firmware/memmap.c:59:25: warning: symbol 'memmap_start_attr'
was not declared. Should it be static?
  drivers/firmware/memmap.c:60:25: warning: symbol 'memmap_end_attr'
was not declared. Should it be static?
  drivers/firmware/memmap.c:61:25: warning: symbol 'memmap_type_attr'
was not declared. Should it be static?

Signed-off-by: Thomas De Schampheleire <patrickdepinguin@gmail.com>
---
 drivers/firmware/memmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 3bf8ee1..261b9aa 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -56,9 +56,9 @@ struct memmap_attribute {
        ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
 };

-struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
-struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
-struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
+static struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
+static struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
+static struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);

 /*
  * These are default attributes that are added for every memmap entry.

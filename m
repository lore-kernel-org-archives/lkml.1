Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYGNC7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYGNC7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYGNC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:57:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:19719 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbYGNC55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=SboWAATWZDiJWOLTax3MRNLVjrnyAWa1DNUdTa6Dd/ZbLyfDaGBZiAwl5NEWj2P8TU
         XCziOCzcqjh5xZqOnhK1cVtZTzioN4j+VFff08spYyJtqCwQBSoz0oBTDWoWG+Glt9v5
         KiNHu3kvhCFzaKOyCasgGmBfGPih7YRvf7Nkg=
Message-Id: <20080714025753.322968991@gmail.com>
References: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:36 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch -mmotm 5/6] fix firmware-use-memory_read_from_buffer.patch
Content-Disposition: inline; filename=firmware-use-memory_read_from_buffer-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/firmware_class.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mmotm/drivers/base/firmware_class.c
===================================================================
--- 2.6-mmotm.orig/drivers/base/firmware_class.c
+++ 2.6-mmotm/drivers/base/firmware_class.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
-#include <linux/fs.h>
 
 #include <linux/firmware.h>
 #include "base.h"

-- 

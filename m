Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbZGaDJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbZGaDJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 23:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZGaDJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 23:09:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34121 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZGaDJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 23:09:05 -0400
Message-ID: <4A726051.8080705@oss.ntt.co.jp>
Date: Fri, 31 Jul 2009 12:09:05 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: rusty@rustcorp.com.au, ericvh@gmail.com,
       v9fs-developer@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Virtio 9p: get rid of redundant VIRTIO_ID_9P definition
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIRTIO_ID_9P is already defined in include/linux/virtio_9p.h
so use that definition instead.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc4-orig/net/9p/trans_virtio.c linux-2.6.31-rc4/net/9p/trans_virtio.c
--- linux-2.6.31-rc4-orig/net/9p/trans_virtio.c	2009-07-29 17:17:58.573055979 +0900
+++ linux-2.6.31-rc4/net/9p/trans_virtio.c	2009-07-31 11:50:16.135410972 +0900
@@ -337,8 +337,6 @@ static void p9_virtio_remove(struct virt
  	}
  }

-#define VIRTIO_ID_9P 9
-
  static struct virtio_device_id id_table[] = {
  	{ VIRTIO_ID_9P, VIRTIO_DEV_ANY_ID },
  	{ 0 },

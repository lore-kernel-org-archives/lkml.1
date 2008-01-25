Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYAYSCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYAYSCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbYAYSBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:01:44 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37846 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293AbYAYSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:01:42 -0500
Date: Fri, 25 Jan 2008 19:02:15 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] unifdef linux/vt.h
Message-ID: <20080125180215.GA30039@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


remove the newly added __KERNEL__ block from linux/vt.h

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/Kbuild |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -157,7 +157,6 @@ header-y += veth.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
-header-y += vt.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -348,6 +347,7 @@ unifdef-y += videodev.h
 unifdef-y += virtio_config.h
 unifdef-y += virtio_blk.h
 unifdef-y += virtio_net.h
+unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h

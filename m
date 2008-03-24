Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbYCXPLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbYCXPLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbYCXPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:10:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:15624 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419AbYCXPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=I0u/59ovhThEovbLgaZQK2RHG8/77zgrM5oCUoz9m+E2XvE1GDKhddBtn1YpwH5gSBINytVkx/LlldCbw9bOT5LcQcQr7EMwgD42I0jausm5uq4bIdpjywb/zdjvEpv8ew53jbBXVsw7OrJOcGX+h/ph+rN1BvS6IYm+dB0yUo4=
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] compcache: Documentation
Date: Mon, 24 Mar 2008 20:36:13 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242036.13668.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compcache usage documentation.

Signed-off-by: Nitin Gupta <nitingupta910 at gmail dot com>
---

 Documentation/compcache.txt |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/compcache.txt b/Documentation/compcache.txt
new file mode 100644
index 0000000..9ece295
--- /dev/null
+++ b/Documentation/compcache.txt
@@ -0,0 +1,24 @@
+
+compcache: Compressed RAM based swap device
+-------------------------------------------
+
+Project home: http://code.google.com/p/compcache
+
+* Introduction
+This is a RAM based block device which acts as swap disk.
+Pages swapped to this device are compressed and stored in
+memory itself.
+
+* Usage
+ - modprobe compcache compcache_size_kbytes=<size>
+   (If no size is specified, default size of 25% of RAM is taken).
+ - swapon /dev/ramzswap0
+
+* Notes
+ - Allocator and compcache statistics are exported via /proc interface:
+   - /proc/tlsfinfo
+   - /proc/compcache
+
+
+Nitin Gupta
+(nitingupta910 at gmail dot com)

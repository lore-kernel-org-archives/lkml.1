Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXDIDBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXDIDBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 23:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXDIDBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 23:01:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:41215 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXDIDBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 23:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cxQvXeyhJU9sa1dV51kMrQDYtt366E32eel4PYo/RtgdGKcAgeSnGLAG1v68a/VDurNaff5yUZYO6TAZ0raiy2Tc6MVFcuDIVeJ2m70oLZzpUzn3BL3szZ9A+qUJk/R3TyQfPevhhT5BrAGLb4XHvD1r5rKLQswEzgASArCuhxQ=
Message-ID: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com>
Date: Mon, 9 Apr 2007 11:01:01 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: netdev@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The option CONFIG_PACKET_MMAP should depend on MMU.

Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
---
 net/packet/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/packet/Kconfig b/net/packet/Kconfig
index 34ff93f..959c272 100644
--- a/net/packet/Kconfig
+++ b/net/packet/Kconfig
@@ -17,7 +17,7 @@ config PACKET

 config PACKET_MMAP
 	bool "Packet socket: mmapped IO"
-	depends on PACKET
+	depends on PACKET && MMU
 	help
 	  If you say Y here, the Packet protocol driver will use an IO
 	  mechanism that results in faster communication.
-- 
1.5.1

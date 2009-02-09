Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZBIVae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZBIVae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZBIVaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:30:20 -0500
Received: from broadrack.ru ([195.178.208.66]:34688 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbZBIVaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:30:18 -0500
Date: Tue, 10 Feb 2009 00:30:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: GregKH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [10/9] pohmelfs: select crypto modules from the config.
Message-ID: <20090209213015.GA14562@ioremap.net>
References: <1234188162-14727-1-git-send-email-zbr@ioremap.net> <1234188162-14727-2-git-send-email-zbr@ioremap.net> <1234188162-14727-3-git-send-email-zbr@ioremap.net> <1234188162-14727-4-git-send-email-zbr@ioremap.net> <1234188162-14727-5-git-send-email-zbr@ioremap.net> <1234188162-14727-6-git-send-email-zbr@ioremap.net> <1234188162-14727-7-git-send-email-zbr@ioremap.net> <1234188162-14727-8-git-send-email-zbr@ioremap.net> <1234188162-14727-9-git-send-email-zbr@ioremap.net> <1234188162-14727-10-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234188162-14727-10-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
index 82d13ad..d4cbc15 100644
--- a/drivers/staging/pohmelfs/Kconfig
+++ b/drivers/staging/pohmelfs/Kconfig
@@ -1,6 +1,8 @@
 config POHMELFS
 	tristate "POHMELFS filesystem support"
 	select CONNECTOR
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HMAC
 	help
 	  POHMELFS stands for Parallel Optimized Host Message Exchange Layered File System.
 	  This is a network filesystem which supports coherent caching of data and metadata


-- 
	Evgeniy Polyakov

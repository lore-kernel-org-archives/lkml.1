Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYDTKlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYDTKlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYDTKj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:39:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbYDTKj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:39:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Hans-J=C3=BCrgen=20Koch?= <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/36] UIO: arch/arm/Kconfig: Make UIO available on ARM architecture
Date: Sun, 20 Apr 2008 03:45:34 -0700
Message-Id: <1208688366-9252-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Jürgen Koch <hjk@linutronix.de>

Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.

Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4039a13..1165a8f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1174,6 +1174,8 @@ source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
 
+source "drivers/uio/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
-- 
1.5.4.5


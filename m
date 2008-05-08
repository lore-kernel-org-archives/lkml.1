Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYEHIBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYEHIBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYEHIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:01:35 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:53446 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYEHIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:01:33 -0400
Date: Thu, 8 May 2008 10:01:30 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Alchemy: export get_au1x00_speed for modules
Message-ID: <20080508080130.GB24383@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508080040.GA24383@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9c59794676b21768624335cc21a7f455b4e69057 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 13:42:55 +0200
Subject: [PATCH] Alchemy: export get_au1x00_speed for modules

au1xmmc.c driver depends on it, so export it for modules.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/clocks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/au1000/common/clocks.c b/arch/mips/au1000/common/clocks.c
index 3ce6cac..6dbc87a 100644
--- a/arch/mips/au1000/common/clocks.c
+++ b/arch/mips/au1000/common/clocks.c
@@ -46,7 +46,7 @@ unsigned int get_au1x00_speed(void)
 {
 	return au1x00_clock;
 }
-
+EXPORT_SYMBOL(get_au1x00_speed);
 
 
 /*
-- 
1.5.5.1


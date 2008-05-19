Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYESIEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYESIEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYESIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:04:19 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:35019 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYESIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:04:18 -0400
Date: Mon, 19 May 2008 10:04:16 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
Message-ID: <20080519080416.GB21985@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519080339.GA21985@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 13:42:55 +0200
Subject: [PATCH] Alchemy: export get_au1x00_speed for modules

au1xmmc.c driver depends on it, so export it for modules.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/clocks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/au1000/common/clocks.c b/arch/mips/au1000/common/clocks.c
index 46f8ee0..043429d 100644
--- a/arch/mips/au1000/common/clocks.c
+++ b/arch/mips/au1000/common/clocks.c
@@ -45,6 +45,7 @@ unsigned int get_au1x00_speed(void)
 {
 	return au1x00_clock;
 }
+EXPORT_SYMBOL(get_au1x00_speed);
 
 /*
  * The UART baud base is not known at compile time ... if
-- 
1.5.5.1


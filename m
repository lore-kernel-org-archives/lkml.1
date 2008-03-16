Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYCPVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYCPVjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 17:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYCPVjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 17:39:04 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:35369 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYCPVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 17:38:26 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc5-mm1 build failure of pcsp.c
Date: Sun, 16 Mar 2008 22:38:21 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, perex@perex.cz
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803162238.21576.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	The build on my laptop (32bit x86) fails.

sound/drivers/pcsp/pcsp.c: In function 'snd_pcsp_create':
sound/drivers/pcsp/pcsp.c:54: error: 'loops_per_jiffy' undeclared (first use in this function)
sound/drivers/pcsp/pcsp.c:54: error: (Each undeclared identifier is reported only once
sound/drivers/pcsp/pcsp.c:54: error: for each function it appears in.)

Seems like the patch below is needed.

	Mariusz

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- linux-2.6.25-rc5-mm1-a/sound/drivers/pcsp/pcsp.c	2008-03-16 21:34:28.000000000 +0100
+++ linux-2.6.25-rc5-mm1-b/sound/drivers/pcsp/pcsp.c	2008-03-16 21:58:58.000000000 +0100
@@ -12,6 +12,7 @@
 #include <sound/initval.h>
 #include <sound/pcm.h>
 #include <linux/input.h>
+#include <linux/delay.h>
 #include <asm/bitops.h>
 #include "pcsp_input.h"
 #include "pcsp.h"

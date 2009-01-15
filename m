Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbZAOVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbZAOVpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAOVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:45:43 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:30580
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbZAOVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:45:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlYBAOA9b0l8qMTI/2dsb2JhbAAIzxCFcQ
X-IronPort-AV: E=Sophos;i="4.37,272,1231081200"; 
   d="scan'208";a="378061814"
Subject: [PATCH] atmel_pcm: Remove non-existant header
From: Ben Nizette <bn@niasdigital.com>
To: sedji.gaouaou@atmel.com
Cc: broonie@opensource.wolfsonmicro.com,
       linux-kernel <linux-kernel@vger.kernel.org>, tiwai@suse.de
Content-Type: text/plain
Date: Fri, 16 Jan 2009 08:45:45 +1100
Message-Id: <1232055945.2714.160.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


<mach/hardware.h> doesn't exist on AVR32 and therefore this driver won't
build on that arch.  AFAICT this driver doesn't actually use the content
of that header so easiest just to remove it.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---

diff --git a/sound/soc/atmel/atmel-pcm.c b/sound/soc/atmel/atmel-pcm.c
index 1fac5ef..3dcdc4e 100644
--- a/sound/soc/atmel/atmel-pcm.c
+++ b/sound/soc/atmel/atmel-pcm.c
@@ -44,8 +44,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
-#include <mach/hardware.h>
-
 #include "atmel-pcm.h"
 
 



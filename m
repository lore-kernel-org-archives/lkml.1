Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXGAU35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXGAU35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbXGAUXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46925 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759514AbXGAUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:37 -0400
Date: Sun, 1 Jul 2007 22:24:03 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: [-mm patch] unexport dvb_pll_configure
Message-ID: <20070701202403.GB10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-dvb.patch
>...
>  git trees
>...


Now that it's static, it should no longer be exported to modules...

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/media/dvb/frontends/dvb-pll.c.old	2007-07-01 21:42:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/media/dvb/frontends/dvb-pll.c	2007-07-01 21:42:25.000000000 +0200
@@ -587,7 +587,6 @@
 	// calculate the frequency we set it to
 	return (div * desc->entries[i].stepsize) - desc->iffreq;
 }
-EXPORT_SYMBOL(dvb_pll_configure);
 
 static int dvb_pll_release(struct dvb_frontend *fe)
 {


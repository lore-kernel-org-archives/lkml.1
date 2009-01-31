Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZAaDH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZAaDH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZAaCrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:39 -0500
Received: from kroah.org ([198.145.64.141]:55422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755338AbZAaCra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:30 -0500
Date: Fri, 30 Jan 2009 18:43:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 23/43] drm: stash AGP include under the do-we-have-AGP ifdef
Message-ID: <20090131024301.GX12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-stash-agp-include-under-the-do-we-have-agp-ifdef.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 1bb88edb7a3769992026f34fd648bb459b0469aa upstream.

This fixes the MIPS with DRM build.

Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_agpsupport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_agpsupport.c
+++ b/drivers/gpu/drm/drm_agpsupport.c
@@ -33,10 +33,11 @@
 
 #include "drmP.h"
 #include <linux/module.h>
-#include <asm/agp.h>
 
 #if __OS_HAS_AGP
 
+#include <asm/agp.h>
+
 /**
  * Get AGP information.
  *


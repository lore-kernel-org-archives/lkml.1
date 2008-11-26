Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYKZQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYKZQOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYKZQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:13:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49945 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYKZQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:13:38 -0500
Date: Wed, 26 Nov 2008 17:15:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Subject: aperture_64.c: clarify that too small aperture is valid reason for
	this code
Message-ID: <20081126161527.GE1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clarify that too small aperture is valid reason for this code.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 9a32b37..026fcfb 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -1,8 +1,9 @@
 /*
  * Firmware replacement code.
  *
- * Work around broken BIOSes that don't set an aperture or only set the
- * aperture in the AGP bridge.
+ * Work around broken BIOSes that don't set an aperture, only set the
+ * aperture in the AGP bridge, or set too small aperture.
+ *
  * If all fails map the aperture over some low memory.  This is cheaper than
  * doing bounce buffering. The memory is lost. This is done at early boot
  * because only the bootmem allocator can allocate 32+MB.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

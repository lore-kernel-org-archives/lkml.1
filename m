Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZGBPa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZGBPa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZGBPaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:30:19 -0400
Received: from quickstop.soohrt.org ([85.131.246.152]:50104 "EHLO
	quickstop.soohrt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGBPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:30:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 11:30:18 EDT
Date: Thu, 2 Jul 2009 17:23:38 +0200
From: Horst Schirmeier <horst@schirmeier.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: [PATCH] doc: missing value 2 for randomize-va-space
Message-ID: <20090702152338.GU26384@quickstop.soohrt.org>
Mail-Followup-To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for /proc/sys/kernel/* does not mention the possible
value 2 for randomize-va-space (but already mentions what it does).

Signed-off-by: Horst Schirmeier <horst@schirmeier.com>
---
 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 322a00b..b2af4ef 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -310,7 +310,7 @@ that support this feature.
     loaded to random addresses. Also for PIE-linked binaries, the location
     of code start is randomized.
 
-    With heap randomization, the situation is a little bit more
+2 - With heap randomization, the situation is a little bit more
     complicated.
     There a few legacy applications out there (such as some ancient
     versions of libc.so.5 from 1996) that assume that brk area starts

-- 
PGP-Key 0xD40E0E7A

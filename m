Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKSGR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKSGR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYKSGRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:17:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYKSGRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:17:20 -0500
Date: Wed, 19 Nov 2008 17:17:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: [PATCH] cirrusfb: remove unused variables
Message-Id: <20081119171708.0c0c4d23.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences:

drivers/video/cirrusfb.c: In function 'cirrusfb_setup':
drivers/video/cirrusfb.c:2466: warning: unused variable 'i'
drivers/video/cirrusfb.c:2465: warning: unused variable 's'

introduced by commit a1d35a7a50d01b445e29d87f479f8c055a414f7e "cirrusfb:
use modedb and add mode_option parameter" which removed the uses of
these variables.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/cirrusfb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 8a87602..a2aa6dd 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
 
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
-	char *this_opt, s[32];
-	int i;
+	char *this_opt;
 
 	DPRINTK("ENTER\n");
 
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

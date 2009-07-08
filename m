Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbZGHQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbZGHQLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbZGHQLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:11:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbZGHQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:11:32 -0400
Subject: [PATCH 41/44] includecheck fix: include/linux, rfkill.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:25:54 +0530
Message-Id: <1247068554.4382.106.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/linux/rfkill.h: linux/types.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/rfkill.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e73e242..2ce2983 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -99,7 +99,6 @@ enum rfkill_user_states {
 #undef RFKILL_STATE_UNBLOCKED
 #undef RFKILL_STATE_HARD_BLOCKED
 
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
-- 
1.6.0.6




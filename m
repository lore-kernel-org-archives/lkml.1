Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208Ab0ANW2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0ANW2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892Ab0ANW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:38 -0500
Received: from kroah.org ([198.145.64.141]:60577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0ANW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Sascha Hauer <s.hauer@pengutronix.de>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Oskar Schirmer <os@emlix.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/52] lib/rational.c needs module.h
Date: Thu, 14 Jan 2010 14:27:02 -0800
Message-Id: <1263508051-7868-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-22-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 7ee3aebe31d2cb22c84e1c8f48182947b13a3607 upstream.

lib/rational.c:62: warning: data definition has no type or storage class
lib/rational.c:62: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
lib/rational.c:62: warning: parameter names (without types) in function declaration

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/rational.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/rational.c b/lib/rational.c
index b3c099b..3ed247b 100644
--- a/lib/rational.c
+++ b/lib/rational.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/rational.h>
+#include <linux/module.h>
 
 /*
  * calculate best rational approximation for a given fraction
-- 
1.6.6


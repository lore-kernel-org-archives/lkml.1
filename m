Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZJLUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZJLUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZJLUxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:53:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:34962 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbZJLUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DYzwmZEFbfbB2jhwljizKAehqAN5L8TkPHbMzmMvd/PWtB5wlAM+IGUmSB8DzwbQYc
         adK6P1xlFHzeWpeoKjvJ1kaRnbI9UWF+7FKP21J79oTvmSVCqKeFCpdciYsmSVVSl6Dy
         GCla2JVQE03wozOutjf75cBGXftlFP/irW+Ms=
From: Tommi Rantala <tt.rantala@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] page-types: constify read only arrays
Date: Mon, 12 Oct 2009 23:51:33 +0300
Message-Id: <1255380694-4122-1-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify read only arrays.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 Documentation/vm/page-types.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 3ec4f2a..16fb478 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -100,7 +100,7 @@
 #define BIT(name)		(1ULL << KPF_##name)
 #define BITS_COMPOUND		(BIT(COMPOUND_HEAD) | BIT(COMPOUND_TAIL))
 
-static char *page_flag_names[] = {
+static const char *page_flag_names[] = {
 	[KPF_LOCKED]		= "L:locked",
 	[KPF_ERROR]		= "E:error",
 	[KPF_REFERENCED]	= "R:referenced",
@@ -173,7 +173,7 @@ static int		kpageflags_fd;
 static int		opt_hwpoison;
 static int		opt_unpoison;
 
-static char		*hwpoison_debug_fs = "/debug/hwpoison";
+static const char	hwpoison_debug_fs[] = "/debug/hwpoison";
 static int		hwpoison_inject_fd;
 static int		hwpoison_forget_fd;
 
@@ -885,7 +885,7 @@ static void parse_bits_mask(const char *optarg)
 }
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "raw"       , 0, NULL, 'r' },
 	{ "pid"       , 1, NULL, 'p' },
 	{ "file"      , 1, NULL, 'f' },
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbYDYK3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbYDYK3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYDYK2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:28:43 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36952 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbYDYK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:28:42 -0400
X-IronPort-AV: E=Sophos;i="4.25,707,1199682000"; 
   d="scan'208";a="52531681"
From: Bryan Wu <cooloney@kernel.org>
To: pmarques@grupopie.com, linux-kernel@vger.kernel.org
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] kallsyms: Nuke all ChangeLog, this should be logged by git
Date: Fri, 25 Apr 2008 18:28:19 +0800
Message-Id: <1209119299-27894-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Paulo:
"When I wrote this initially, it was a mistake to add a Changelog
in the first place, but I didn't know better at the time.

If you're going to make changes to this file, please remove all the
Changelog, instead of adding more entries to it. The "Changelog"
should be kept by the version control system, and not the source code itself."

Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 scripts/kallsyms.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 0f7269f..868a4c8 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -7,12 +7,6 @@
  *
  * Usage: nm -n vmlinux | scripts/kallsyms [--all-symbols] > symbols.S
  *
- * ChangeLog:
- *
- * (25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
- *      Changed the compression method from stem compression to "table lookup"
- *      compression
- *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
  *  map char code 0xF7 to represent "write_" and then in every symbol where
-- 
1.5.5

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbYA3RuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbYA3RuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbYA3RuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:50:12 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:54644 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYA3RuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:50:10 -0500
X-IronPort-AV: E=Sophos;i="4.25,278,1199682000"; 
   d="scan'208";a="61244416"
Subject: [PATCH] [Scripts] kallsyms: Nuke all ChangeLog, this should be
	logged by git
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Robin Getz <robin.getz@analog.com>
In-Reply-To: <47A05CBA.2030903@grupopie.com>
References: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
	 <47A05CBA.2030903@grupopie.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 31 Jan 2008 01:49:53 +0800
Message-Id: <1201715393.6530.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 30 Jan 2008 17:50:09.0361 (UTC) FILETIME=[8E347410:01C86368]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2375c7eaa43d4474fb5b403dba9b3175e683484a Mon Sep 17 00:00:00 2001
From: Bryan Wu <bryan.wu@analog.com>
Date: Thu, 31 Jan 2008 01:30:09 +0800
Subject: [PATCH] [Scripts] kallsyms: Nuke all ChangeLog, this should be logged by git

(25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
Changed the compression method from stem compression
to "table lookup" compression

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 scripts/kallsyms.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 5271db7..1dab50e 100644
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
1.5.3.4


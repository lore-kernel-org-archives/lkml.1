Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbXENKDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbXENKDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbXENKC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:02:58 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45598 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXENKC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:02:57 -0400
Message-ID: <4648342C.3020208@freescale.com>
Date: Mon, 14 May 2007 18:04:28 +0800
From: Li Yang <leoli@freescale.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: fix wrong warning message in modpost
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2007 10:02:43.0104 (UTC) FILETIME=[03848200:01C7960F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of the "Section mismatch" warning message in modpost.c
is in wrong format.  This patch fix it.

Signed-off-by: Li Yang <leoli@freescale.com>
---

 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..c89cb71 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -906,7 +906,7 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	} else {
 		warn("%s - Section mismatch: reference to %s:%s from %s "
 		     "(offset 0x%llx)\n",
-		     modname, secname, fromsec, refsymname,
+		     modname, secname, refsymname, fromsec,
 		     (long long)r.r_offset);
 	}
 }


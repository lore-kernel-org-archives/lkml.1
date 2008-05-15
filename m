Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbYEOLDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbYEOLDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYEOLDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:03:24 -0400
Received: from sacred.ru ([62.205.161.221]:39066 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYEOLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:03:23 -0400
Message-ID: <482C17DE.70705@openvz.org>
Date: Thu, 15 May 2008 15:00:46 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/10] Bsdacct: "truthify" a comment near acct_process
References: <482C15FE.7070300@openvz.org>
In-Reply-To: <482C15FE.7070300@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 15 May 2008 15:03:06 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acct_process does not accept any arguments actually.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 kernel/acct.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index ee3e605..d9ee183 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -579,7 +579,6 @@ void acct_collect(long exitcode, int group_dead)
 
 /**
  * acct_process - now just a wrapper around do_acct_process
- * @exitcode: task exit code
  *
  * handles process accounting for an exiting task
  */
-- 
1.5.3.4

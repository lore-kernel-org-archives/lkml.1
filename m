Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYDJJCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYDJJCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYDJJBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:01:53 -0400
Received: from sacred.ru ([62.205.161.221]:60008 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYDJJBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:01:52 -0400
Message-ID: <47FDD3A8.3010901@openvz.org>
Date: Thu, 10 Apr 2008 12:45:28 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/10] Bsdacct: fix bogus comment near acct_process
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:20:37 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not accept any arguments :)

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


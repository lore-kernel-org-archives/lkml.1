Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZELJdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZELJdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbZELJcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:32:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760141AbZELJcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:32:41 -0400
Date: Tue, 12 May 2009 09:31:49 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, bernhard@schiffner-limbach.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, bernhard@schiffner-limbach.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1242090794.7214.131.camel@localhost.localdomain>
References: <1242090794.7214.131.camel@localhost.localdomain>
Subject: [tip:timers/ntp] ntp: fix comment typos
Message-ID: <tip-e13cf6e04ebc231653e03ebde4799dc55bf62849@git.kernel.org>
Git-Commit-ID: e13cf6e04ebc231653e03ebde4799dc55bf62849
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 09:31:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e13cf6e04ebc231653e03ebde4799dc55bf62849
Gitweb:     http://git.kernel.org/tip/e13cf6e04ebc231653e03ebde4799dc55bf62849
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Mon, 11 May 2009 18:13:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 10:35:15 +0200

ntp: fix comment typos

Bernhard Schiffner noticed I had a few comment typos in this patch,
(note: to save embarrassment, when making typos, avoid copying and
pasting them) so this patch corrects them.

[ Impact: cleanup ]

Reported-by: Bernhard Schiffner <bernhard@schiffner-limbach.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
LKML-Reference: <1242090794.7214.131.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/timex.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 0daf961..9910e3b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -179,7 +179,7 @@ struct timex {
  * NTP convergence time. A higher value makes it stiffer, increasing
  * convergence time, but making the clock more stable.
  *
- * In David Mills' nanokenrel reference implmentation SHIFT_PLL is 4.
+ * In David Mills' nanokernel reference implementation SHIFT_PLL is 4.
  * However this seems to increase convergence time much too long.
  *
  * https://lists.ntp.org/pipermail/hackers/2008-January/003487.html
@@ -196,7 +196,7 @@ struct timex {
  *
  * SHIFT_FLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in FLL mode.
- * In David Mills' nanokenrel reference implmentation SHIFT_PLL is 2.
+ * In David Mills' nanokernel reference implementation SHIFT_FLL is 2.
  *
  * MAXTC establishes the maximum time constant of the PLL.
  */

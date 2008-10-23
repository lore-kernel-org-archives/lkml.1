Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYJWJe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYJWJe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYJWJeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:34:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33130 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYJWJet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:34:49 -0400
Message-ID: <490043DE.4000802@oracle.com>
Date: Thu, 23 Oct 2008 17:29:02 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/13 v2] ftrace: clean ups and fixes
References: <20081022212721.167005680@goodmis.org>
In-Reply-To: <20081022212721.167005680@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
just several trivial things.

[PATCH 02/13 v2] ftrace: dynamic ftrace process only text section
+# Acceptible sections to record.

typo - Acceptible

[PATCH 03/13 v2] ftrace: return error on failed modified text.
+ * This is a very sensitive operatation and great care needs

typo - operatation
Why not put comments to function definition?

[PATCH 04/13 v2] ftrace: comment arch ftrace code
+	 *  as well as code changing. We do this by using the
+	 *  __copy_*_user functions.

According to [PATCH 05/13], change to using the proper API for reading 
and writing, not __copy_*_user.


Regards,
Wenji

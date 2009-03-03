Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZCCPPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZCCPPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCCPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:15:27 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33526 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753043AbZCCPP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:15:26 -0500
Date: Tue, 3 Mar 2009 09:15:24 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6 v6] SGI RTC: export clocksource_unregister
Message-ID: <20090303151524.GB20120@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303151357.GA20120@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export clocksource_unregister().

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 kernel/time/clocksource.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c	2009-03-02 08:20:32.000000000 -0600
+++ linux/kernel/time/clocksource.c	2009-03-02 08:20:53.000000000 -0600
@@ -370,6 +370,7 @@ void clocksource_unregister(struct clock
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL_GPL(clocksource_unregister);
 
 #ifdef CONFIG_SYSFS
 /**

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZCCPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZCCPRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZCCPRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:17:00 -0500
Received: from relay3.sgi.com ([192.48.171.31]:44120 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbZCCPQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:16:59 -0500
Date: Tue, 3 Mar 2009 09:16:57 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6 v6] SGI RTC: export clockevents_register_device
Message-ID: <20090303151657.GC20120@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303151524.GB20120@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export clockevents_register_device().

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 kernel/time/clockevents.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c	2009-03-02 08:20:32.000000000 -0600
+++ linux/kernel/time/clockevents.c	2009-03-02 08:20:56.000000000 -0600
@@ -187,6 +187,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZCCPSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZCCPSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZCCPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:18:30 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33454 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754677AbZCCPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:18:29 -0500
Date: Tue, 3 Mar 2009 09:18:27 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6 v6] SGI RTC: export schedule_on_each_cpu
Message-ID: <20090303151827.GD20120@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com> <20090303151657.GC20120@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303151657.GC20120@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export schedule_on_each_cpu().

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 kernel/workqueue.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/workqueue.c
===================================================================
--- linux.orig/kernel/workqueue.c	2009-03-02 08:20:32.000000000 -0600
+++ linux/kernel/workqueue.c	2009-03-02 08:20:57.000000000 -0600
@@ -705,6 +705,7 @@ int schedule_on_each_cpu(work_func_t fun
 	free_percpu(works);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(schedule_on_each_cpu);
 
 void flush_scheduled_work(void)
 {

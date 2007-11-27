Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbXK0Jea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbXK0Jea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXK0JeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:34:22 -0500
Received: from mga10.intel.com ([192.55.52.92]:51705 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752458AbXK0JeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:34:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,218,1194249600"; 
   d="scan'208";a="404215075"
Subject: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: mingo@elte.hu
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 27 Nov 2007 17:33:05 +0800
Message-Id: <1196155985.25646.31.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If echo "1">/proc/sys/kernel/sched_compat_yield before starting volanoMark
testing, the result is very good with kernel 2.6.24-rc3 on my 16-core tigerton.

1) If /proc/sys/kernel/sched_compat_yield=1, comparing with 2.6.22,
2.6.24-rc3 has more than 70% improvement;
2) If /proc/sys/kernel/sched_compat_yield=0, comparing with 2.6.22,
2.6.24-rc3 has more than 80% regression;

On other machines, the volanoMark result also has much improvement if
/proc/sys/kernel/sched_compat_yield=1.

Would you like to change function yield_task_fair to delete codes around
sysctl_sched_compat_yield, or just initiate it to 1?

Thanks,
Yanmin

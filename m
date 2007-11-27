Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbXK0EyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbXK0EyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXK0EyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:54:06 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35530 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXK0EyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:54:03 -0500
Date: Tue, 27 Nov 2007 10:36:52 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [Patch 0/5] sched: group scheduler related patches (V4)
Message-ID: <20071127050652.GA20083@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126202836.GA17012@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 09:28:36PM +0100, Ingo Molnar wrote:
> the first SCHED_RR priority is 1, not 0 - so this call will always fail.

Thanks for spotting this bug and rest of your review comments.

Here's V4 of the patchset, aimed at improving fairness of cpu bandwidth
allocation for task groups.

Changes since V3 (http://marc.info/?l=linux-kernel&m=119605252303359):

- Fix bug in setting SCHED_RR priority for load_balance_monitor thread
- Fix coding style related issues
- Separate "introduction of lock_doms_cur() API" into a separate patch

I have also tested this patchset against your latest git tree as of
today morning.

Please apply if there are no major concerns.


-- 
Regards,
vatsa

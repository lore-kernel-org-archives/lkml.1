Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbXKSSIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbXKSSIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXKSSI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:08:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49452 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXKSSI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:08:26 -0500
Date: Mon, 19 Nov 2007 23:51:13 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [PATCH 0/2] sched: group scheduler related patches (V2)
Message-ID: <20071119182113.GA25404@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
        Here's V2 of the two patches related to group cpu scheduling I
sent a while ago:

Patch 1/2 -> Fixes minor bugs and coding style issues
Patch 2/2 -> Improves group fairness on SMP systems.

Changes since V1:
	- Introduced a task_group_mutex to serialize add/removal of
	  task groups (as pointed by Dipankar)

Both the patches should not have any functional/runtime effect to the scheduler
for !CONFIG_FAIR_GROUP_SCHED case.

This is also probably one of the last big changes related to group scheduler
that I had on my plate. Pls apply if there is no objection from anyone.

-- 
Regards,
vatsa

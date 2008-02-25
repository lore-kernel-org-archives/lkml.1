Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYBYOP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYBYOP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYBYOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:15:17 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46354 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYBYOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:15:15 -0500
Date: Mon, 25 Feb 2008 19:45:04 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: [RFC, PATCH 0/2] sched: add multiple hierarchy support to the CFS
	group scheduler
Message-ID: <20080225141504.GA27746@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

These patches change the fairness model as discussed in
http://lkml.org/lkml/2008/1/30/634

Patch 1 -> Changes the fairness model
Patch 2 -> Allows one to create multiple levels of cgroups

The second patch is not very good with SMP yet, that is the next TODO.
Also it changes the behaviour of fair user. The root task group is the
parent task group and the other users are its children.

Thanks,
-- 
regards,
Dhaval

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZCCPsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZCCPsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZCCPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:48:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZCCPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:48:44 -0500
Subject: Re: [PATCH 2 2/3] sched: Fix the wakeup nomination for
 sched_mc/smt_power_savings.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090303154537.GI4708@dirshya.in.ibm.com>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
	 <20090303115149.605.92140.stgit@sofia.in.ibm.com>
	 <1236083033.5330.4204.camel@laptop> <20090303135907.GA23822@elte.hu>
	 <20090303154537.GI4708@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 16:48:26 +0100
Message-Id: <1236095306.5330.4777.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 21:15 +0530, Vaidyanathan Srinivasan wrote:

> I had earlier posted cleanup for find_busiest_group(), but Peter
> mentioned that he is changing the cpu_power infrastructure and I can
> rework the cleanup after that.

Right, I need to get back to pondering that problem. The whole 1/x thing
doesn't really work.


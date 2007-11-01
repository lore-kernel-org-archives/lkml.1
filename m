Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXKAMDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXKAMDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXKAMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:03:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXKAMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:03:22 -0400
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1193918299.27652.260.camel@twins>
References: <20071031211030.310581000@chello.nl>
	 <20071031211248.796653000@chello.nl>
	 <20071101113138.GA20788@linux.vnet.ibm.com>
	 <1193917912.27652.258.camel@twins>  <1193918299.27652.260.camel@twins>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 13:03:18 +0100
Message-Id: <1193918598.27652.262.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 12:58 +0100, Peter Zijlstra wrote:

> > sched_slice() is about lantecy, its intended purpose is to ensure each
> > task is ran exactly once during sched_period() - which is
> > sysctl_sched_latency when nr_running <= sysctl_sched_nr_latency, and
> > otherwise linearly scales latency.

The thing that got my brain in a twist is what to do about the non-leaf
nodes, for those it seems I'm not doing the right thing - I think.


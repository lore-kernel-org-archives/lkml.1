Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZH1TSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZH1TSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZH1TSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:18:09 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41709 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZH1TSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:18:08 -0400
Date: Sat, 29 Aug 2009 00:48:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [Patch 0/3] [Patch 0/3] HW-BKPT: Introduce new features to the
	hw-breakpoint infrastructure - ver II
Message-ID: <20090828191801.GA11063@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
        Please find a set of patches that implement the features listed
below, the previous version of which was posted here: 
http://lkml.org/lkml/2009/8/26/477

Patch 1/2: Allow per-cpu kernel-space Hardware Breakpoint requests
Patch 2/2: Allow kernel breakpoints to be modified through a new API
Patch 3/3: Allow breakpoints to be enabled/disabled without yielding the
breakpoint request through a new API - enable_hw_breakpoint().

Changelog ver II
-----------------
- Fixed a potential race between updation of per-cpu kernel-space breakpoint
  structures and a concurrent breakpoint exception by disabling breakpoints
  in remove_each_cpu_kernel_hbp() through a new function
  arch_disable_hw_breakpoint().
- Change the data-type of 'enabled' member in 'struct hw_breakpoint' to 'bool'.
- Split the enable_hw_breakpoint() interface to bring a counterpart in
  disable_hw_breakpoint().
- Modify stale/incorrect comments.
- Code updated to commit 1468c4ea3af77ac75de7aae80a44522ff5d0d6c5 of
  -tip tree.

Thanks,
K.Prasad


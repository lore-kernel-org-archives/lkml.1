Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZHZUOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZHZUOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZHZUOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:14:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50672 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZHZUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:14:14 -0400
Date: Thu, 27 Aug 2009 01:44:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 0/3] HW-BKPT: Introduce new features to the hw-breakpoint
	infrastructure
Message-ID: <20090826201404.GA12766@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a set of patches that implement the features listed
below. This is a sequel to the patchset posted yesterday
http://lkml.org/lkml/2009/8/25/371 and contains a new patch 3/3.
 
Patch 1/2: Allow per-cpu kernel-space Hardware Breakpoint requests
Patch 2/2: Allow kernel breakpoints to be modified through a new API
Patch 3/3: Allow breakpoints to be enabled/disabled without yielding the
breakpoint request through a new API - enable_hw_breakpoint().

During discussion on LKML, these features were deemed necessary for
effective exploitation of hardware breakpoints by perf-tools.
 
The patches are based off -tip tree. Kindly let me know your comments
on the same.
 
Thanks,
K.Prasad


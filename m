Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbZHYUVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbZHYUVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZHYUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:21:01 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37507 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZHYUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:21:00 -0400
Date: Wed, 26 Aug 2009 01:50:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 0/2] HW-BKPT: Introduce per-cpu breakpoints and
	modify_kernel_hw_breakpoint API
Message-ID: <20090825202053.GA1166@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a set of patches that implement the following:

Patch 1/2: Allow per-cpu kernel-space Hardware Breakpoint requests
Patch 2/2: Allow kernel breakpoints to be modified through a new API

During discussion on LKML, these features were deemed necessary for
effective exploitation of hardware breakpoints by perf-tools.

The patches are based off -tip tree. Kindly let me know your comments
on the same.

Thanks,
K.Prasad


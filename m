Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZJZVQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZJZVQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZJZVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:16:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39318 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZJZVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:16:45 -0400
Date: Tue, 27 Oct 2009 02:46:37 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC Patch 0/4] Enhance perf-events to profile memory accesses
	using hw-breakpoints
Message-ID: <20091026211637.GA15529@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please review a set of patches that enhance the
perf-events infrastructure to use hw-breakpoints layer to monitor accesses over
kernel-space addresses/symbols, apart from bringing a few related enhancements
to the hw-breakpoint layer.
	
These patches are still under development and is based off -tip tree
(commit 77a088cd30a7bd2c700bf57544732fff6971305e) and are known to have a few
issues (listed in patch 3/3).

Patch 1/4: Allow per-cpu kernel-space Hardware Breakpoint requests
(originally posted here http://lkml.org/lkml/2009/8/17/172)
Patch 2/4: Allow breakpoints to be enabled/disabled on the fly (without yielding
them to other contenders).
Patch 3/4: Bugfix HW-BKPT: Fix traceback seen when resuming after suspend-to-ram
Patch 4/4: Enhance perf-events to profile memory accesses over kernel symbols

Comments on the same will be appreciated!

Thanks,
K.Prasad


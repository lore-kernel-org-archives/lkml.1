Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXISG25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXISG25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 02:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXISG2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 02:28:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:34618 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751520AbXISG2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 02:28:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+TQ0xblRSTJxtivlJ4AkAmm2FWNagBNNGsrSblaj
	4cqBmcU+r/5Wk1
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 08:28:44 +0200
Message-Id: <1190183324.9737.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

On Tue, 2007-09-18 at 23:03 -0700, Tong Li wrote:
> This patch attempts to improve CFS's SMP global fairness based on the new 
> virtual time design.
> 
> Removed vruntime adjustment in set_task_cpu() as it skews global fairness.

Since I'm (still) encountering Xorg latency issues (which go away if
load is hefty instead of light) even with that migration adjustment and
synchronization, and am having difficulty nailing it down to a specific
event, I'll test this immediately.

	-Mike


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXITEz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXITEz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 00:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXITEzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 00:55:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:44059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750719AbXITEzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 00:55:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tbT5fDddtKQFpIPdFcnO/nK25LfyXj9xNX9UzQV
	60gFBoxr15ZPhm
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 06:55:14 +0200
Message-Id: <1190264114.6411.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 10:06 -0700, Tong Li wrote:

> Were the experiments run on a 2-CPU system?

Yes.

>  When Xorg experiences large 
> wait time, is it on the same CPU that has the two pinned tasks? If this is 
> the case, then the problem could be X somehow advanced faster and got a 
> larger vruntime then the two pinned tasks, so it had to wait for the 
> pinned ones to catch up before it got a chance to be scheduled.

Good question.  I've not yet been able to capture any event where
vruntimes are that far apart in sched_debug.

	-Mike


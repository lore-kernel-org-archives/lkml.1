Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXITIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXITIRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbXITILR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:11:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:38244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760847AbXITILO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:11:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IhgUQfyWItmPiDbDtM3JZzH37delhuy004Wfml1
	JrppajCDznjHYU
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tong Li <tong.n.li@intel.com>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070920075155.GA31641@elte.hu>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 10:11:10 +0200
Message-Id: <1190275870.9232.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 09:51 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > [...]  I modified the kernel to print task's actual tree key instead 
> > of their current vruntime, [...]
> 
> btw., that looks like a debug printout bug in sched-devel.git - could 
> you send me your fix? I've pushed out the latest sched-devel (ontop of 
> -rc7) to the usual place:

Well, I temporarily added a key field, which is only used to store the
key for debug...

>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> (note that there are some debug printout updates which might clash with 
> your fix)

I'll pull/build this and test my migration problem there.  All I have to
do is to add a nice 19 chew-max to my make -j2, and all hell breaks
loose.  Always suspecting myself first in the search for dirty rotten
SOB who broke local scheduler :) I nuked the migration fix.  Looks like
I'm not the SOB this time.. it got much worse, with max Xorg latency of
>500ms.

	-Mike


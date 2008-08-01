Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbYHAVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbYHAVR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbYHAVKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40886 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760649AbYHAVKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:42 -0400
Date: Fri, 1 Aug 2008 14:10:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: recent -git: BUG in free_thread_xstate
Message-ID: <20080801211036.GU14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com> <20080723203109.GH14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723203109.GH14380@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:31:09PM -0700, Suresh Siddha wrote:
> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
> > Hi,
> > 
> > I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
> > yesterday):
> 
> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
> changes.
> 
> > 
> > BUG: unable to handle kernel paging request at 00664381
> > IP: [<c010b274>] free_thread_xstate+0x4/0x30
> ...
> 
> > EIP is at arch/x86/kernel/process.c:36:
> > 
> >         if (tsk->thread.xstate) {
> > 
> 
> It looks like the kernel stack of that process got corrupted, corrupting the
> task pointer in thread_info. Can you send us your config file?

I would also like to see the config file.

							Thanx, Paul

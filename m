Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbZAOM2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbZAOM2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZAOM2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:28:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:60766 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755163AbZAOM2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:28:32 -0500
Date: Thu, 15 Jan 2009 13:28:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Kaibin Li <kaibinlee@gmail.com>, trivial@kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Remove a duplicated option of RCU_CPU_STALL_DETECTOR
In-Reply-To: <20090113233450.GD6756@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.1.10.0901151327470.5377@jikos.suse.cz>
References: <20090113140636.1515e11f@zenwalk.fortinet.com> <alpine.LNX.1.10.0901132346150.5377@jikos.suse.cz> <20090113233450.GD6756@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Paul E. McKenney wrote:

> > > There is a duplicated option of "Check for stalled CPUs delaying RCU
> > > grace periods" in Kernel hacking.
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks.

> > > Signed-off-by: Kaibin Li <kaibinlee@gmail.com>
> > > ---
> > >  lib/Kconfig.debug |   13 -------------
> > >  1 files changed, 0 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index 4c9ae60..e770e85 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
> > >  
> > >  config RCU_CPU_STALL_DETECTOR
> > >     bool "Check for stalled CPUs delaying RCU grace periods"
> > > -   depends on CLASSIC_RCU
> > > -   default n
> > > -   help
> > > -     This option causes RCU to printk information on which
> > > -     CPUs are delaying the current grace period, but only when
> > > -     the grace period extends for excessive time periods.
> > > -
> > > -     Say Y if you want RCU to perform such checks.
> > > -
> > > -     Say N if you are unsure.
> > > -
> > > -config RCU_CPU_STALL_DETECTOR
> > > -   bool "Check for stalled CPUs delaying RCU grace periods"
> > >     depends on CLASSIC_RCU || TREE_RCU
> > >     default n
> > >     help
> > 
> > The RCU_CPU_STALL_DETECTOR indeed is duplicate, but the entries themselves 
> > are not identical, as they have different dependencies.
> > 
> > Paul -- does Kaibin's patch remove the correct one? If so, I can take it 
> > through trivial tree.
> Indeed it is:  http://lkml.org/lkml/2008/12/23/167  ;-)
> CCing Ingo in case he has it queued up.

It doesn't seem to be present in today's -next, so I have queued up in 
trivial tree.

thanks,

-- 
Jiri Kosina
SUSE Labs

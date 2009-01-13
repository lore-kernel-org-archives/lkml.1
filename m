Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZAMXfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZAMXfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZAMXew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:34:52 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38404 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbZAMXew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:34:52 -0500
Date: Tue, 13 Jan 2009 15:34:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kaibin Li <kaibinlee@gmail.com>, trivial@kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Remove a duplicated option of RCU_CPU_STALL_DETECTOR
Message-ID: <20090113233450.GD6756@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090113140636.1515e11f@zenwalk.fortinet.com> <alpine.LNX.1.10.0901132346150.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901132346150.5377@jikos.suse.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:48:44PM +0100, Jiri Kosina wrote:
> On Tue, 13 Jan 2009, Kaibin Li wrote:
> 
> > There is a duplicated option of "Check for stalled CPUs delaying RCU
> > grace periods" in Kernel hacking.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> > Signed-off-by: Kaibin Li <kaibinlee@gmail.com>
> > ---
> >  lib/Kconfig.debug |   13 -------------
> >  1 files changed, 0 insertions(+), 13 deletions(-)
> > 
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 4c9ae60..e770e85 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
> >  
> >  config RCU_CPU_STALL_DETECTOR
> >     bool "Check for stalled CPUs delaying RCU grace periods"
> > -   depends on CLASSIC_RCU
> > -   default n
> > -   help
> > -     This option causes RCU to printk information on which
> > -     CPUs are delaying the current grace period, but only when
> > -     the grace period extends for excessive time periods.
> > -
> > -     Say Y if you want RCU to perform such checks.
> > -
> > -     Say N if you are unsure.
> > -
> > -config RCU_CPU_STALL_DETECTOR
> > -   bool "Check for stalled CPUs delaying RCU grace periods"
> >     depends on CLASSIC_RCU || TREE_RCU
> >     default n
> >     help
> 
> The RCU_CPU_STALL_DETECTOR indeed is duplicate, but the entries themselves 
> are not identical, as they have different dependencies.
> 
> Paul -- does Kaibin's patch remove the correct one? If so, I can take it 
> through trivial tree.

Indeed it is:  http://lkml.org/lkml/2008/12/23/167  ;-)

CCing Ingo in case he has it queued up.

							Thanx, Paul

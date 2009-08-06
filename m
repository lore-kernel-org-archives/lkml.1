Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZHFN7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZHFN7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZHFN7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:59:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43627 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbZHFN7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:59:07 -0400
Date: Thu, 6 Aug 2009 06:59:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090806135907.GA7192@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu> <20090803125618.GV6854@linux.vnet.ibm.com> <20090806012645.GA24800@linux.vnet.ibm.com> <20090806025105.GA7077@in.ibm.com> <20090806122935.GB15314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806122935.GB15314@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:29:35PM +0200, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > On Wed, Aug 05, 2009 at 06:26:45PM -0700, Paul E. McKenney wrote:
> > > On Mon, Aug 03, 2009 at 05:56:18AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> > > > > 
> > > > > i've attached the full serial bootlog with the warning in it. This 
> > > > > should address your question about what the order of initialization 
> > > > > is, right?
> > > > 
> > > > It does, thank you!  This problem really is happening during boot.
> > > > 
> > > > > Let me know if you still would like me to run your diagnostic patch 
> > > > > too.
> > > > 
> > > > Now that you mention it, you should probably let me test it a bit first.
> > > 
> > > And here is a tested and debugged version.  Diagnostic only, not for
> > > inclusion, based on tip/core/rcu as of today (August 5th).
> > > 
> > > Gautham, have you been able to reproduce on your machines?  
> > > Still cannot here.
> > 
> > I tried on a couple of machines yesterday, but I still couldn't 
> > reproduce it with Ingo's config.
> 
> Paul, should i try your latest diagnostic patch in -tip testing, to 
> see whether it triggers any new warning?

Could you please?

							Thanx, Paul

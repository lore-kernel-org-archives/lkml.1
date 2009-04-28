Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZD1QQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZD1QQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbZD1QP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:15:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43949 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbZD1QP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:15:59 -0400
Date: Tue, 28 Apr 2009 21:45:36 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090428161536.GE7178@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <1240826954.8216.8.camel@twins> <20090427142044.GA7178@dirshya.in.ibm.com> <1240907618.7620.86.camel@twins> <20090428085237.GB26487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090428085237.GB26487@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-04-28 10:52:37]:

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > > Also, the user interface should be that single thermal 
> > > > capacity knob, more fine grained control is undesired.
> > > 
> > > For power savings, a single evacuation knob will do.  While for 
> > > thermal we will need additional parameters to choose the right 
> > > cores to evacuate.  Some sort of directional/vector parameter.
> > 
> > Why? are machines that non-uniform in cooling capacity that it 
> > really matters which core generates the heat? Sounds like badly 
> > designed hardware to me.
> > 
> > I would expect it to only be the total head generated/power taken 
> > from the rack unit.
> 
> If we add thermal throttling at the kernel level then a single knob 
> (with a percentile-ish unit) is probably the furthest we will go - 
> with "not doing it at all" still being the other, very tempting 
> alternative.

Sure, this is all we would like to do.  Simpler interface is welcome
and will have easy adoption.
 
> If the only technical way you can find to do it is via myriads of 
> non-intuitive knobs and per core settings - then the answer is 
> really 'no thanks'.

Agreed.  We definitely do not want to add myriads of non-intuitive
knobs.  Lets see if a percentage/capacity type knob will work for all.

Thanks,
Vaidy


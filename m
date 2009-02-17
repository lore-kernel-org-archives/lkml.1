Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZBQHAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZBQHAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZBQHAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:00:09 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33639 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZBQHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:00:08 -0500
Date: Tue, 17 Feb 2009 12:29:56 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       suresh.b.siddha@intel.com, balbir@in.ibm.com, dipankar@in.ibm.com,
       efault@gmx.de, andi@firstfloor.org
Subject: Re: [PATCH 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
Message-ID: <20090217065956.GB28515@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com> <20090216165111.12804.41620.stgit@sofia.in.ibm.com> <1234806323.30178.189.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234806323.30178.189.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 06:45:23PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-02-16 at 22:21 +0530, Gautham R Shenoy wrote:
> > @@ -520,6 +520,11 @@ struct root_domain {
> >          * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
> >          */
> >         unsigned int sched_mc_preferred_wakeup_cpu;
> > +       /*
> > +        * The sched-domain level which is authorized to nominate the preferred
> > +        * wake up cpu.
> > +        */
> > +       enum sched_domain_level authorized_nomination_level
> 
> Some day my brain is just going to explode.. ;-)
> 
> Can we do a nice concise writeup of the power-save dynamics somewhere?

Sure, will work on that one.

-- 
Thanks and Regards
gautham

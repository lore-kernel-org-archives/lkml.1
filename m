Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZBQG4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZBQG4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 01:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZBQG4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 01:56:15 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34795 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZBQG4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 01:56:14 -0500
Date: Tue, 17 Feb 2009 12:25:42 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       suresh.b.siddha@intel.com, balbir@in.ibm.com, dipankar@in.ibm.com,
       efault@gmx.de, andi@firstfloor.org
Subject: Re: [PATCH 1/3] sched: code cleanup - sd_power_saving_flags(),
	sd_balance_for_mc/package_power()
Message-ID: <20090217065542.GA28515@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com> <20090216165105.12804.32344.stgit@sofia.in.ibm.com> <1234806181.30178.183.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234806181.30178.183.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 06:43:01PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-02-16 at 22:21 +0530, Gautham R Shenoy wrote:
> 
> > +enum sched_domain_level {
> > +	SD_LV_NONE = 0,
> > +	SD_LV_SIBLING,
> > +	SD_LV_MC,
> > +	SD_LV_CPU,
> > +	SD_LV_NODE,
> > +	SD_LV_ALLNODES,
> > +	SD_LV_MAX
> > +};
> 
> 
> Better names would be:
> 
>  LV_THREAD
>  LV_CORE
>  LV_PACKAGE
>  LV_NODE
> 
> But I realize that renaming these is going to be painful, however could
> we at least provide proper comments with these to describe them. I
> always get confused.

Will do the comments for now.

While on the topic, it might also be a good thing to discuss/consider renaming.
I am for it, since these newer names are much more intuitive when compared to
the existing ones.

>

-- 
Thanks and Regards
gautham

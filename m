Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXIXRHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXIXRHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbXIXRHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:07:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51660 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759830AbXIXRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:07:40 -0400
Date: Mon, 24 Sep 2007 22:48:20 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 5/5] Add fair "control groups" scheduler
Message-ID: <20070924171820.GI5657@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924164159.GF10291@linux.vnet.ibm.com> <20070924095815.9d5f7f32.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924095815.9d5f7f32.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:58:15AM -0700, Randy Dunlap wrote:
> > +	config FAIR_CGROUP_SCHED
> > +		bool "Control groups"
> > +		depends on CGROUPS
> > +		help
> > +		   This option allows you to create arbitrary task groups
> > +		   using the "cgroup" psuedo filesystem and control
> > +		   the cpu bandwidth allocated to each such task group.
> > +		   Refer to Documentation/cgroups.txt for more information
> > +		   on "cgroup" psuedo filesystem.
> 
> Too much indentation.
> 
> s/cpu/CPU/g please.

will fix both.

> > +config RESOURCE_COUNTERS
> > +	bool "Resource counters"
> > +	help
> > +	  This option enables controller independent resource accounting
> > +          infrastructure that works with cgroups
> 
> Use tab + 2 spaces to indent help text.

This one was there before in -mm ..I just moved it below in the Kconfig
file. Neverthless will fix the coding-style here as well.

Thanks for your reviews!

-- 
Regards,
vatsa

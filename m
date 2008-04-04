Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbYDDOtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbYDDOtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYDDOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:48:56 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59581 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbYDDOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:48:55 -0400
Date: Fri, 4 Apr 2008 20:18:25 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080404144825.GB890@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080403191916.GA30864@deepthought> <200804032329.22483.rjw@sisk.pl> <20080403234839.GA5181@deepthought> <200804040220.00732.rjw@sisk.pl> <20080404123717.GA19045@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404123717.GA19045@deepthought>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:37:17PM +0100, Ken Moffat wrote:
> On Fri, Apr 04, 2008 at 02:20:00AM +0200, Rafael J. Wysocki wrote:
> > On Friday, 4 of April 2008, Ken Moffat wrote:
> > > On Thu, Apr 03, 2008 at 11:29:21PM +0200, Rafael J. Wysocki wrote:
> > > > 
> > > > Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
> > > > (see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).
> > > > 
> > > > Thanks,
> > > > Rafael
> > >  Thanks for the suggestion.  Tried it on 2.6.24.4, and
> > > double-checked /proc/config.gz after booting -
> > > 
> > > # CONFIG_FAIR_GROUP_SCHED is not set
> > > 
> > >  Unfortunately, the first test reboot failed in the same way.
> > 
> > Please unset CONFIG_GROUP_SCHED too.
> > 
> > Thanks,
> > Rafael
> 
>  Yet again, I'm confused.  I thought you'd missed a word in what you
> asked because the config for 2.6.24.4 doesn't show this.
> ken@bluesbreaker ~ $zgrep GROUP /proc/config.gz 
> # CONFIG_CGROUPS is not set
> # CONFIG_FAIR_GROUP_SCHED is not set
> ken@bluesbreaker ~ $
> 
>  I _can_ see it in the 2.6.25 configs (except for rc1).  Will retry
> rc8 with them both turned off.
> 

Right, in 2.6.24 we called it CONFIG_FAIR_GROUP_SCHED since group
scheduling was available only for CFS. In 2.6.25 we have group
scheduling for RT as well, so it is called CONFIG_GROUP_SCHED now.

-- 
regards,
Dhaval

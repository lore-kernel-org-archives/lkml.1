Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYDDPCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYDDPCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYDDPCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:02:34 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:30705 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150AbYDDPCd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:02:33 -0400
Date: Fri, 4 Apr 2008 16:02:21 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080404150221.GB21753@deepthought>
References: <20080403191916.GA30864@deepthought> <200804032329.22483.rjw@sisk.pl> <20080403234839.GA5181@deepthought> <200804040220.00732.rjw@sisk.pl> <20080404123717.GA19045@deepthought> <20080404144825.GB890@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080404144825.GB890@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 08:18:25PM +0530, Dhaval Giani wrote:
> On Fri, Apr 04, 2008 at 01:37:17PM +0100, Ken Moffat wrote:
> > On Fri, Apr 04, 2008 at 02:20:00AM +0200, Rafael J. Wysocki wrote:
> > > On Friday, 4 of April 2008, Ken Moffat wrote:
> > > > On Thu, Apr 03, 2008 at 11:29:21PM +0200, Rafael J. Wysocki wrote:
> > > > > 
> > > > > Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
> > > > > (see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).
> > > > > 
> > > > > Thanks,
> > > > > Rafael
> > > >  Thanks for the suggestion.  Tried it on 2.6.24.4, and
> > > > double-checked /proc/config.gz after booting -
> > > > 
> > > > # CONFIG_FAIR_GROUP_SCHED is not set
> > > > 
> > > >  Unfortunately, the first test reboot failed in the same way.
> > > 
> > > Please unset CONFIG_GROUP_SCHED too.
> > > 
> > > Thanks,
> > > Rafael
> > 
> >  Yet again, I'm confused.  I thought you'd missed a word in what you
> > asked because the config for 2.6.24.4 doesn't show this.
> > ken@bluesbreaker ~ $zgrep GROUP /proc/config.gz 
> > # CONFIG_CGROUPS is not set
> > # CONFIG_FAIR_GROUP_SCHED is not set
> > ken@bluesbreaker ~ $
> > 
> >  I _can_ see it in the 2.6.25 configs (except for rc1).  Will retry
> > rc8 with them both turned off.
> > 
> 
> Right, in 2.6.24 we called it CONFIG_FAIR_GROUP_SCHED since group
> scheduling was available only for CFS. In 2.6.25 we have group
> scheduling for RT as well, so it is called CONFIG_GROUP_SCHED now.
> 
> -- 
> regards,
> Dhaval
 OK, thanks for the explanation.  Just gave -rc8 the first test with
CONFIG_GROUP_SCHED unset, and again it fails.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYDDPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYDDPAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYDDPAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:00:10 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:29705 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759247AbYDDPAI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:00:08 -0400
Date: Fri, 4 Apr 2008 16:00:01 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080404150001.GA21753@deepthought>
References: <20080403191916.GA30864@deepthought> <200804032156.54021.rjw@sisk.pl> <20080403210840.GA2292@deepthought> <200804032329.22483.rjw@sisk.pl> <20080403234839.GA5181@deepthought> <20080404144712.GA890@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080404144712.GA890@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 08:17:12PM +0530, Dhaval Giani wrote:
> On Fri, Apr 04, 2008 at 12:48:39AM +0100, Ken Moffat wrote:
> > On Thu, Apr 03, 2008 at 11:29:21PM +0200, Rafael J. Wysocki wrote:
> > > 
> > > Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
> > > (see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).
> > > 
> > > Thanks,
> > > Rafael
> >  Thanks for the suggestion.  Tried it on 2.6.24.4, and
> > double-checked /proc/config.gz after booting -
> > 
> > # CONFIG_FAIR_GROUP_SCHED is not set
> > 
> >  Unfortunately, the first test reboot failed in the same way.
> > 
> 
> Just to confirm. The bug happens even when CONFIG_FAIR_GROUP_SCHED is
> unset?
> 
> -- 
> regards,
> Dhaval
 Yes.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce

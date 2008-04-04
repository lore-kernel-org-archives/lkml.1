Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbYDDOsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbYDDOsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYDDOrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:47:51 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:34921 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbYDDOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:47:50 -0400
Date: Fri, 4 Apr 2008 20:17:12 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080404144712.GA890@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080403191916.GA30864@deepthought> <200804032156.54021.rjw@sisk.pl> <20080403210840.GA2292@deepthought> <200804032329.22483.rjw@sisk.pl> <20080403234839.GA5181@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403234839.GA5181@deepthought>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 12:48:39AM +0100, Ken Moffat wrote:
> On Thu, Apr 03, 2008 at 11:29:21PM +0200, Rafael J. Wysocki wrote:
> > 
> > Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
> > (see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).
> > 
> > Thanks,
> > Rafael
>  Thanks for the suggestion.  Tried it on 2.6.24.4, and
> double-checked /proc/config.gz after booting -
> 
> # CONFIG_FAIR_GROUP_SCHED is not set
> 
>  Unfortunately, the first test reboot failed in the same way.
> 

Just to confirm. The bug happens even when CONFIG_FAIR_GROUP_SCHED is
unset?

-- 
regards,
Dhaval

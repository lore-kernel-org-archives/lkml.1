Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZBWLqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZBWLqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZBWLqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:46:14 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:35975 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZBWLqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:46:13 -0500
Date: Mon, 23 Feb 2009 17:15:41 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090223114541.GD31277@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090216103636.GC17355@linux.vnet.ibm.com> <1234782516.4703.15.camel@laptop> <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com> <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org> <20090217050033.GA10409@linux.vnet.ibm.com> <20090217101542.GB15989@linux.vnet.ibm.com> <1234869339.4744.77.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234869339.4744.77.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:15:39PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 15:45 +0530, Dhaval Giani wrote:
> 
> > sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> > 
> > Corey Hickey reported that on using setuid to change the uid of a
> > rt process, the process would be unkillable and not be running.
> > This is because there was no rt runtime for that user group. Add
> > in a check to see if a user can attach an rt task to its task group.
> 
> This looks good to me.
> 
> Does anybody object to the -ENOSPC return value? Should we introduce
> -ENOTIME for that?
> 
> Michael, Alan?
> 

Hi,

Any comments on which return value to return? Should we introduce
-ENOTIME?

Corey mentioned he found ENOSPC confusing.

Thanks,
-- 
regards,
Dhaval

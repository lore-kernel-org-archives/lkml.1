Return-Path: <linux-kernel-owner+w=401wt.eu-S935419AbYEVI2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935419AbYEVI2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbYEVI23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:28:29 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55743 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbYEVI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:28:26 -0400
Date: Thu, 22 May 2008 13:58:14 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
Message-ID: <20080522082814.GA4499@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com> <1211440207.5733.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211440207.5733.8.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:10:07AM +0200, Mike Galbraith wrote:
> 
> On Wed, 2008-05-21 at 13:34 -0400, Greg Smith wrote:
> > PostgreSQL ships with a simple database benchmarking tool named pgbench, 
> > in what's labeled the contrib section (in many distributions it's a 
> > separate package from the main server/client ones).  I see there's been 
> > some work done already improving how the PostgreSQL server works under the 
> > new scheduler (the "Poor PostgreSQL scaling on Linux 2.6.25-rc5" thread). 
> > I wanted to provide you a different test case using pgbench that has taken 
> > a sharp dive starting with 2.6.23, and the server improvement changes in 
> > 2.6.25 actually made this problem worse.
> > 
> > I think it will be easy for someone else to replicate my results and I'll 
> > go over the exact procedure below.
> 
> Yup, I can reproduce.  Running the test with 2.6.25.4, everything is
> waking/running on one CPU, leaving my box 75% idle.  Not good.
> 

Can you try with 2.6.26-rc? There is minimal load balancing for group
scheduling till 25, which might explain the lack of scalability.

-- 
regards,
Dhaval

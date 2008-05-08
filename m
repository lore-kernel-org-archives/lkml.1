Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYEHJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYEHJhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYEHJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:37:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:54974 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752032AbYEHJhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:37:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189Ri05P2M9xh/lwGyrq9AzAjsz3ZzX4VyL5oVRyq
	OwyT2Hze0/1QYB
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080508084607.GA31515@elte.hu>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net> <20080508084607.GA31515@elte.hu>
Content-Type: text/plain
Date: Thu, 08 May 2008 11:37:34 +0200
Message-Id: <1210239454.7036.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 10:46 +0200, Ingo Molnar wrote:

> Could you perhaps try the hack below that uses /proc/sys/kernel/panic as 
> a flag whether the BKL should cause us to block or should be spun upon.
> 
> Can you confirm that with that patch too sysbench shows sensitivity to 
> the value of the panic flag? [this is the surest way to measure such 
> effects as flipping the sysctl only minimally impacts the system.]

Difference for average of 3 runs at 128 clients is 0.3% with this
patch.. iow, nope.

	-Mike


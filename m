Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZKTFib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZKTFib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZKTFia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:38:30 -0500
Received: from mga06.intel.com ([134.134.136.21]:10705 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753585AbZKTFi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:38:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,775,1249282800"; 
   d="scan'208";a="468979357"
Subject: Re: [Bug #14383] hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1258542581.3918.255.camel@laptop>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.65H.2TdALB@chimera>  <1258542581.3918.255.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 20 Nov 2009 13:40:57 +0800
Message-Id: <1258695658.29789.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 12:09 +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-16 at 23:37 +0100, Rafael J. Wysocki wrote:

Sorry for replying late. There was a severe power failure in my Lab.

Below are updates against 2.6.32-rc7 kernel.

> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
> > Subject		: hackbench regression with kernel 2.6.32-rc1
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2009-10-09 9:19 (39 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
> > References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
On core2 arch machines, hackbench regression disappears and there is much
improvement instead of regression. 
On Nehalem machine, no big change, comparing with 2.6.31.

On Itanium machines (2 sockets or 4 sockets), the regression become
about 20%. Originally it's 70%.


> 
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14384
> > Subject         : tbench regression with 2.6.32-rc1
> > Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date            : 2009-10-09 9:51 (39 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
> > References      : http://marc.info/?l=linux-kernel&m=125508216713138&w=4
> > Handled-By      : Peter Zijlstra <a.p.zijlstra@chello.nl>

On core2 arch machines, tbench regression becomes about 4%. Originally, the
regression is about 33%.

On Nehalem, tbench regression is about 4%. Original is 7%.

On Itanium, tbench regression is about 16%. Original is 26%


> 
> 
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14621
> > Subject         : specjbb2005 and aim7 regression with 2.6.32-rc kernels
> > Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date            : 2009-11-06 7:38 (11 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125749310413174&w=4
specjbb2005 and aim7 results almost have no variation.

> 
> 
> Yanmin, could you please update me on the status of these regressions?
> 
> Mike seems to have done a lot to address issues while I was out, and
> while I (hopefully) did read all resulting email, I must admit to
> loosing track of where we stand.

Mike's patch 1b9508f6831e10 could improve netperf loopback testing.
The latest upstream doesn't merge it yet.




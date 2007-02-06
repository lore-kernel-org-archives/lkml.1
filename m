Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbXBFSQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbXBFSQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXBFSQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:16:43 -0500
Received: from colin.muc.de ([193.149.48.1]:4266 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXBFSQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:16:43 -0500
Date: 6 Feb 2007 19:16:41 +0100
Date: Tue, 6 Feb 2007 19:16:41 +0100
From: Andi Kleen <ak@muc.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
Message-ID: <20070206181641.GA35903@muc.de>
References: <200702060352.l163q87K000713@zach-dev.vmware.com> <1170736029.29293.31.camel@localhost.localdomain> <45C809F9.2090905@vmware.com> <1170738676.29293.35.camel@localhost.localdomain> <1170752856.7324.5.camel@laptopd505.fenrus.org> <20070206122514.GA47229@muc.de> <1170765952.7324.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170765952.7324.15.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 01:45:52PM +0100, Arjan van de Ven wrote:
> On Tue, 2007-02-06 at 13:25 +0100, Andi Kleen wrote:
> > > hmm stolen time could even be useful without virtualization; to a large
> > > degree, if cpufreq reduces the speed of your cpu you have "stolen
> > > cycles" that way... I wonder if this concept can be used for that as
> > > well...
> 
> > 
> > I don't see the point, frankly.
> 
> I mean for showing the sysadmin that his system has spare capacity left.
> 
> right now top shows 50% in use (at say 600Mhz) while the 2.8Ghz
> processor obviously isn't even nearly half loaded.

Not necessarily.

You have no guarantee that it will go much faster at full frequency.
e.g. if the workload is memory bound then core frequency won't affect it
much.

Also if you're using automatic frequency scaling (which probably
the far majority of users do) then if anything keeps the system
busy for some time it will scale up anyways. This means even at 50%
load you will be likely running at full speed already.

I suspect there will be that many variables that automatic adjustment
is probably not useful.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYEIHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYEIHu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 03:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYEIHuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 03:50:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3097 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbYEIHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 03:50:18 -0400
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210318362.15296.4.camel@marge.simson.net>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
	 <1210238622.13978.193.camel@twins>  <1210295779.3453.155.camel@ymzhang>
	 <1210315870.13978.204.camel@twins>
	 <1210318362.15296.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 09 May 2008 09:50:17 +0200
Message-Id: <1210319417.13978.207.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 09:32 +0200, Mike Galbraith wrote:
> On Fri, 2008-05-09 at 08:51 +0200, Peter Zijlstra wrote:
> > > > > -rc1.  Do you have the fix below applied?
> > > > 
> > > > Oooh - good catch, that seems to be a post -rc1 merge.
> > > > 
> > > > Yes this is required.
> > 
> > > With below patch+previous_fix_weight_calc, the result is improved, but is still
> > > about 10% worse than the one of pure 2.6.26-rc1.
> > > Number of threads: 16
> > >     read/write requests:                 6104336 (50867.11 per sec.)
> > > 
> > 
> > So puzzling - could you try -git + fix_weight_calc, as I think that is
> > what Mike tested and proved good on his Quad.
> 
> If he still has group scheduling enabled, my box agrees that there's a
> regression.  I got mysql running, and tested with group scheduling both
> enabled and disabled, results attached.  (for some reason, I can only
> test up to 64 threads with mysql though)

Hm, ok. Does the patch at hand improve or regress the group config for
you?


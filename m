Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYEIGvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYEIGvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYEIGvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:51:17 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:46619 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYEIGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:51:12 -0400
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210295779.3453.155.camel@ymzhang>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
	 <1210238622.13978.193.camel@twins>  <1210295779.3453.155.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 09 May 2008 08:51:10 +0200
Message-Id: <1210315870.13978.204.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > -rc1.  Do you have the fix below applied?
> > 
> > Oooh - good catch, that seems to be a post -rc1 merge.
> > 
> > Yes this is required.

> With below patch+previous_fix_weight_calc, the result is improved, but is still
> about 10% worse than the one of pure 2.6.26-rc1.
> Number of threads: 16
>     read/write requests:                 6104336 (50867.11 per sec.)
> 

So puzzling - could you try -git + fix_weight_calc, as I think that is
what Mike tested and proved good on his Quad.




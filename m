Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXCLJXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXCLJXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965430AbXCLJXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:23:21 -0400
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:47459 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965426AbXCLJXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:23:21 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 20:22:42 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703121929.39702.kernel@kolivas.org> <1173689733.6748.18.camel@Homer.simpson.net>
In-Reply-To: <1173689733.6748.18.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122022.43021.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> On Mon, 2007-03-12 at 19:29 +1100, Con Kolivas wrote:
> > I'll save you the trouble. I just checked myself and indeed the load is
> > only 1. What this means is that although there are 2 tasks running, only
> > one is running at any time making a total load of 1. So, if we add two
> > other tasks that add 2 more to the load the total load is 3. However if
> > we weight the other two tasks at nice 5, they only add .75 each to the
> > load making a weighted total of 2.5. This means that X+Gforce together
> > should get a total of 1/2.5 or 40% of the overall cpu. That sounds like
> > exactly what you're describing is happening.
>
> Hmm.  So... anything that's client/server is going to suffer horribly
> unless niced tasks are niced all the way down to 19?

Fortunately most client server models dont usually have mutually exclusive cpu 
use like this X case. There are many things about X that are still a little 
(/me tries to think of a relatively neutral term)... wanting. :(

-- 
-ck

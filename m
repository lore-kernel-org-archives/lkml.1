Return-Path: <linux-kernel-owner+w=401wt.eu-S1766962AbXEBRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766962AbXEBRuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766920AbXEBRuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:50:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38288 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766958AbXEBRuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:50:08 -0400
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
From: john stultz <johnstul@us.ibm.com>
To: Peter Keilty <peter.keilty@hp.com>
Cc: linux-ia64@vger.kernel.org, Eric Whitney <eric.whitney@hp.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4631F26D.7080404@hp.com>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
	 <1177622301.6031.16.camel@localhost.localdomain>  <4631F26D.7080404@hp.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 10:50:01 -0700
Message-Id: <1178128202.6183.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 08:54 -0400, Peter Keilty wrote:
> john stultz wrote:
> >On Thu, 2007-04-26 at 16:26 -0400, Peter Keilty wrote:
> >>From: Peter Keilty <peter.keilty@hp.com>
> >>
> >>Initial ia64 conversion to the generic timekeeping/clocksource code.
> >>
> >>Signed-off-by: Peter Keilty <peter.keilty@hp.com>
> >>Signed-off-by: John Stultz <johnstul@us.ibm.com>
> >>    
> >	Thanks so much for pushing this on! I suspect this patch needs to be
> >updated a touch, as I'm not sure if it still compiles in light of recent
> >changes...
> >
> You are correct, you need patch 3/3 for it to compile and run.
> I did a patch to the orginal patch, thought that was correct thing to do.
> But I can make a new patch 1 from the orginal of ours and my #3.
> I would also make an update to the #2 patch from #3 for ntp correct change.
> That would be just 2 patches then, the enable_ia64 and remove_interpolater.
> What do you think?

Yep. That sounds like the right path to me. Its a good idea to make sure
your patch set compiles each step of the way, so later folks can
properly bisect through it looking for other issues.

thanks
-john





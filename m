Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXLDASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXLDASn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXLDASf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:18:35 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28484 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740AbXLDASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:18:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H+wEpk2g0VKLUQ/O7+g9LeRUVXig4N8xWUHRZdAWIyCsjqovS6m/DVAOljgLeyS+mPa1ORjOMGy7xvOi55nCrNiL/uRyEbvgtZDSlfH9+OMzm1g6OdalQrSUHHBomZNU2RIcXg9jq90Xo68NkUz0mz83CbDBT3LSvQ11BcwLVlw=  ;
X-YMail-OSG: DXWFOm8VM1n.P65yf4i.yTqUUqp8asUlnEhwPi.AfEjzdXkV9pWyw5d91oJOKU9T10eRXBKYDw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Tue, 4 Dec 2007 11:18:24 +1100
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Chris Friesen <cfriesen@nortel.com>,
       davids@webmaster.com, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <475480AF.2010307@rtr.ca> <20071203223353.GA20362@elte.hu>
In-Reply-To: <20071203223353.GA20362@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041118.25414.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2007 09:33, Ingo Molnar wrote:
> * Mark Lord <lkml@rtr.ca> wrote:
> >> heh, thanks :) For which workload does it make the biggest difference
> >> for you? (and compared to what other scheduler you used before?
> >> 2.6.22?)
> >
> > ..
> >
> > Heh.. I'm just a very unsophisticated desktop user, and I like it when
> > Thunderbird and Firefox are unaffected by the "make -j3" kernel builds
> > that are often running in another window.  BIG difference there.
> >
> > And on the cool side, the Swarm game (swarm.swf) is a great example of
> > something that used to get jerky really fast whenever anything else
> > was running, and now it really doesn't seem to be affected by
> > anything. (I don't really play computer games, but this one is has a
> > very retro feel..).
>
> nice! Do you feel any difference between 2.6.23 and 2.6.24-rc for these
> workloads? (if you've tried .24 already)

And also, I wonder what the average timeslice and number of context
switches is between 2.6.22 and 2.6.23-4. Would be interesting to see.

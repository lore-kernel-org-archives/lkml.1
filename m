Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYFRDfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYFRDfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbYFRDe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:34:59 -0400
Received: from mga06.intel.com ([134.134.136.21]:12344 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757805AbYFRDe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:34:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,662,1204531200"; 
   d="scan'208";a="296408257"
Message-ID: <48588255.9060400@linux.intel.com>
Date: Tue, 17 Jun 2008 20:34:45 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <1213730654.3803.122.camel@johannes.berg> <20080617194105.GA18177@redhat.com>
In-Reply-To: <20080617194105.GA18177@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Jun 17, 2008 at 09:24:14PM +0200, Johannes Berg wrote:
>  > 
>  > > i have no gripes about the current situation of wireless in linux-next, 
>  > > other than it all came 1-2 years too late:
>  > 
>  > Clearly, you don't have a clue about wireless. I'll admit to being
>  > pissed off by statements like this because I personally spent a lot of
>  > time getting wireless code into shape for merging, and it took a long
>  > time.
>  > 
>  > If we'd have merged the existing wireless drivers 2 years ago, we would
>  > have (at least) four 802.11 stacks in the kernel now, at least two
>  > legally questionable drivers (the ath5k legal situation would probably
>  > never have been cleared up, acx100 still isn't), no uniform API so it
>  > would be impossible to write userspace support tools etc.
> 
> FWIW, the fact that there's so much churn happening in wireless right
> now is IMO, a sign of its health.

I totally agree with that. In fact I'm quite happy with the progress.


> It's been something of a double edged sword.  It's great that users are
> getting the latest drivers & fixes, but at the same time, it means they
> get exposed to all the latest breakage at the same time.
> Given the volume of change occuring, cherry-picking isn't an enviable task,
> so distros are stuck between this reality, or leaving users hanging until we
> get to the next point release.
> 
> FWIW, wireless isn't unique in this regard. For eg, the last few months we've
> always been shipping the latest ALSA bits rather than what's in kernel.org too,
> for similar reasons -- when bugs appear, the developers want to know
> "does it still happen with the latest bits?"
> 


this is the part that concerns me.  The fact that you feel the need to use "not yet in mainline" pieces
(I'm not so much talking about backporting from 2.6.26-git to 2.6.25; that's perfectly fine, but I'm
talking about code not in 2.6.26-git) is NOT a healthy sign.... if that truely is the case then that code surely
deserves to be in mainline as well?

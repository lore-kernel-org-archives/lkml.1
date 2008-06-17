Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYFQTs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYFQTs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYFQTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:48:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbYFQTsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:48:46 -0400
Date: Tue, 17 Jun 2008 15:41:05 -0400
From: Dave Jones <davej@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617194105.GA18177@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	tglx@linutronix.de, linville@tuxdriver.com, gregkh@suse.de
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <1213730654.3803.122.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213730654.3803.122.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 09:24:14PM +0200, Johannes Berg wrote:
 > 
 > > i have no gripes about the current situation of wireless in linux-next, 
 > > other than it all came 1-2 years too late:
 > 
 > Clearly, you don't have a clue about wireless. I'll admit to being
 > pissed off by statements like this because I personally spent a lot of
 > time getting wireless code into shape for merging, and it took a long
 > time.
 > 
 > If we'd have merged the existing wireless drivers 2 years ago, we would
 > have (at least) four 802.11 stacks in the kernel now, at least two
 > legally questionable drivers (the ath5k legal situation would probably
 > never have been cleared up, acx100 still isn't), no uniform API so it
 > would be impossible to write userspace support tools etc.

FWIW, the fact that there's so much churn happening in wireless right
now is IMO, a sign of its health.  When I told John "commit whatever
wireless bits you think need to be in Fedora" many months back, I admit
I wasn't expecting as much churn as there has been.

It's been something of a double edged sword.  It's great that users are
getting the latest drivers & fixes, but at the same time, it means they
get exposed to all the latest breakage at the same time.
Given the volume of change occuring, cherry-picking isn't an enviable task,
so distros are stuck between this reality, or leaving users hanging until we
get to the next point release.

FWIW, wireless isn't unique in this regard. For eg, the last few months we've
always been shipping the latest ALSA bits rather than what's in kernel.org too,
for similar reasons -- when bugs appear, the developers want to know
"does it still happen with the latest bits?"

The situation isn't perfect, but I don't think it's quite as bleak
as Ingo painted it to be.

	Dave

-- 
http://www.codemonkey.org.uk

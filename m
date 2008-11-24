Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYKXDeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYKXDeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 22:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYKXDd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 22:33:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:39882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYKXDdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 22:33:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,655,1220252400"; 
   d="scan'208";a="407207437"
Subject: Re: pull request: wireless-2.6 2008-11-18
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
In-Reply-To: <20081119143919.GA3485@tuxdriver.com>
References: <20081119000719.GA19756@tuxdriver.com>
	 <1ba2fa240811182246m17a6baf0ybde19af030a65819@mail.gmail.com>
	 <1ba2fa240811190134u7974a840i532e8ed0e18f8c72@mail.gmail.com>
	 <20081119143919.GA3485@tuxdriver.com>
Content-Type: text/plain
Organization: Intel Corp.
Date: Mon, 24 Nov 2008 11:34:15 +0800
Message-Id: <1227497655.2548.257.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 22:39 +0800, John W. Linville wrote:
> Well, thanks for your opinion.  Here is mine:

I have to say something here. Although not related to the original
ieee80211_notify_mac change.

> The iwlwifi drivers have been hitting these problems for months,
> and I have seen no effort by your team to address the problems.
> It is possible that your team is working on them behind closed doors
> and will eventually throw something over the wall to us.  I'm tired
> of waiting for that, and I imagine that hordes of iwlagn users are
> tired of waiting as well.

This is not correct. We are tracing this problem in our bugzilla. And it
is the open place. Much more people have used it for a much longer time
even before the kernel bugzilla existed. If you take a look at the bug,
you know how much effort we put on it:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

> Johannes has presented us with plausible fixes, and people are
> reporting that the patches work for them.  I can merge these patches,
> or wait/hope/pray for some to come from your team.  Experience
> suggests
> that if fixes do come from your team that they will either be buried
> in some monster patch that largely addresses something else, or
> that the patches will arrive with a changelog that is terse and/or
> unintelligble.  Subsequently, I am not optimistic about waiting.
> 
> I think Johannes cited four different bugzilla.kernel.org entries
> between those two patches.  What is your team doing to address
> those bugs?

Johannes' effort is great and should certainly be praised. But looking
down upon Intel's effort is nonsense. We suspected this alignment issue
in the very beginning. But the set of users helped us to debug with this
problem happened to have a different root cause than Johannes. Thus came
with the alignment BUG_ON assert put into the code in case other people
experience with it (unfortunately, it was a wrong one. As I had
appologized for this already.)

The problem should at least have two causes. Johannes had resolved one
of them. The other one (AFAICS) relates to be in an 11n AP environment
(no need to be associated with it) and takes longer time to reproduce.
We will keep tracking it whatever we you think us about it.

Thanks,
-yi


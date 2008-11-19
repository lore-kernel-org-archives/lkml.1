Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYKSOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYKSOq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYKSOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:46:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKSOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:46:13 -0500
Date: Wed, 19 Nov 2008 09:39:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2008-11-18
Message-ID: <20081119143919.GA3485@tuxdriver.com>
References: <20081119000719.GA19756@tuxdriver.com> <1ba2fa240811182246m17a6baf0ybde19af030a65819@mail.gmail.com> <1ba2fa240811190134u7974a840i532e8ed0e18f8c72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811190134u7974a840i532e8ed0e18f8c72@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 11:34:37AM +0200, Tomas Winkler wrote:
> On Wed, Nov 19, 2008 at 8:46 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Wed, Nov 19, 2008 at 2:07 AM, John W. Linville
> > <linville@tuxdriver.com> wrote:

> >>      mac80211: remove ieee80211_notify_mac
> >>      iwlagn: fix RX skb alignment
> >
> > IMHO its premature pushing ttese 2 patches up, they came in yestrday
> > and nobody here has run tthe code
 
Well, thanks for your opinion.  Here is mine:

The iwlwifi drivers have been hitting these problems for months,
and I have seen no effort by your team to address the problems.
It is possible that your team is working on them behind closed doors
and will eventually throw something over the wall to us.  I'm tired
of waiting for that, and I imagine that hordes of iwlagn users are
tired of waiting as well.

Johannes has presented us with plausible fixes, and people are
reporting that the patches work for them.  I can merge these patches,
or wait/hope/pray for some to come from your team.  Experience suggests
that if fixes do come from your team that they will either be buried
in some monster patch that largely addresses something else, or
that the patches will arrive with a changelog that is terse and/or
unintelligble.  Subsequently, I am not optimistic about waiting.

I think Johannes cited four different bugzilla.kernel.org entries
between those two patches.  What is your team doing to address
those bugs?

Obviously, I still think that those patches should be merged.

> Just checked our bug database,  the ieee80211_notify_mac was
> introduced mainly to overcome HW bug when
> receiver become deaf  in heavy traffic such as ftp in noisy
> environment. Otherwise reconnection was too slow to keep ftp going. We
> need to check whether we are still hitting this before applying
> removal this function

You are welcome to submit patches that address your hardware issue
and which do not introduce locking problems.

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

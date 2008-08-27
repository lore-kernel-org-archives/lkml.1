Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYH0PXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYH0PXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYH0PX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:23:29 -0400
Received: from bu3sch.de ([62.75.166.246]:38812 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbYH0PX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:23:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Wed, 27 Aug 2008 17:22:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Marcel Holtmann" <holtmann@linux.intel.com>,
       "David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080827013009.GA15781@tuxdriver.com> <200808271510.35950.mb@bu3sch.de> <1ba2fa240808270755t2f3d0c28rcb874011f5540ef3@mail.gmail.com>
In-Reply-To: <1ba2fa240808270755t2f3d0c28rcb874011f5540ef3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808271722.55627.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 16:55:15 Tomas Winkler wrote:
> I'm not sure what you are taking about, we did post patches to
> wireless-testing, the driver for 5000 HW  is working in 2.6.27-rc4 I
> personally use it every day.  I'm sending bug fixes, like this seris
> of patches is direct answer to bugs that were discovered very
> recently, I'm not sure what's everybody problem here.

The problem is that these patches are posted in huge batches.
There are three problems (probably more) with that:
1) "Oh, one of these 15 patches recently merged broke my hw"
   instead of
   "This patch XXX recently merged broke my hw"
2) It's a _lot_ harder to review. I do not have the time to review
   a lot of patches at once. I bet other people won't either.
3) If somebody has any objections against one patch, you'll probably
   have to rebase them all (See recent pull request vs cleanups).
   That's additional work for you.

What's the problem with sending patches upstream as soon as you finished
them, instead of piling them up locally and sending them alltogether?

> We fixed bugs in wireless-testing/mac80211 that were there for months
> just because we are only one that do any comprehensive validation. I
> don't  want insult anyone and I really exaggeration here but
> sometimes I have feeling that more people are breaking the code.

If you work directly upstream, you will discover these bugs even faster.
If you maintain your local fork of mac80211, you will have a delay. But
you will have to handle them _anyway_. It's just delayed.

And please, don't act like you don't add bugs to mac80211. There were several
bugs that broke connections on b43 (and probably other hw, too) in the past.

-- 
Greetings Michael.

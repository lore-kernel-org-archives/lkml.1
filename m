Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZK3WI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZK3WI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZK3WI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:08:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbZK3WIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:08:55 -0500
Date: Mon, 30 Nov 2009 14:08:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "John W. Linville" <linville@tuxdriver.com>
cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-11-30 (security fixes too)
In-Reply-To: <20091130194706.GE21401@tuxdriver.com>
Message-ID: <alpine.LFD.2.00.0911301406230.2872@localhost.localdomain>
References: <20091130194706.GE21401@tuxdriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, John W. Linville wrote:
> 
> If a) you have already taken Dave's latest pull request; and, b) you
> don't want to wait for his next one to get the mac80211 security fixes
> from Johannes, then you can at your discretion pull from here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git security

Hmm. If I pull the 'security' branch, I get

 drivers/net/wireless/iwlwifi/iwl-tx.c |   10 +++++++++-
 include/net/mac80211.h                |    6 ++++++
 net/mac80211/agg-rx.c                 |    4 ----
 net/mac80211/agg-tx.c                 |   17 ++++++++---------
 net/mac80211/ht.c                     |    8 +++-----
 net/mac80211/ieee80211_i.h            |    2 ++
 6 files changed, 28 insertions(+), 19 deletions(-)

which does not match what you then descibe in the rest of the email 
(changelog and diffstat).

What you describe seems to be the master branch. 

So I'm not going to pull either, and will wait for confirmation of exactly 
what you wanted me to pull.

				Linus

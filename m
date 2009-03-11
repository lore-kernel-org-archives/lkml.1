Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZCKPPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZCKPPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZCKPPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:15:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZCKPPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:15:34 -0400
Date: Wed, 11 Mar 2009 11:11:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.29-rc "TKIP: replay detected" regression
Message-ID: <20090311151102.GC8761@tuxdriver.com>
References: <Pine.LNX.4.64.0903111114510.22922@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903111114510.22922@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:07:54PM +0000, Hugh Dickins wrote:
> Prior to 2.6.29-rc1's 274bfb8dc5ffa16cb073801bebe76ab7f4e2e73d
> "lib80211: absorb crypto bits from net/ieee80211", the TKIP and CCMP
> "replay detected" messages were subject to the IEEE80211_DEBUG_DROP()
> macro, neither I nor my distro had CONFIG_IEEE80211_DEBUG set, I never
> glimpsed such messages, and ThinkPad T43p ipw2200 wireless worked fine.
> 
> -		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
> -			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=%pM"
> +		if (net_ratelimit()) {
> +			printk(KERN_DEBUG "TKIP: replay detected: STA=%pM"

Hugh, this is my mess -- sorry!  I'll follow-up with a patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

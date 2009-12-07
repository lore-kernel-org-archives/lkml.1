Return-Path: <linux-kernel-owner+w=401wt.eu-S935666AbZLGWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666AbZLGWpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934201AbZLGWpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:45:06 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37865 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbZLGWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:45:05 -0500
Date: Mon, 7 Dec 2009 17:32:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net/wireless/wireless-current tree build warning
Message-ID: <20091207223236.GF18939@tuxdriver.com>
References: <20091201133524.32756cef.sfr@canb.auug.org.au> <1260191754.3737.1.camel@johannes.local> <20091208092057.dd2eeaeb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208092057.dd2eeaeb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 09:20:57AM +1100, Stephen Rothwell wrote:
> Hi Dave, John,
> 
> On Mon, 07 Dec 2009 14:15:54 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > > drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_agg_stop':
> > > drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1 of 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type
> > > include/net/mac80211.h:2128: note: expected 'struct ieee80211_vif *' but argument is of type 'struct ieee80211_hw *'
> > 
> > This has now snuck into wireless-testing as well.
> 
> Johannes is right, the patch I posted need to be part of the wireless
> tree once the wireless-current tree was merged into it.  Now this patch
> (reposted below) is needed in the wireless and net trees ...

I've just merged such a patch...thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

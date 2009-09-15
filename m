Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZIOVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZIOVPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZIOVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:15:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56381
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZIOVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:15:49 -0400
Date: Tue, 15 Sep 2009 14:16:06 -0700 (PDT)
Message-Id: <20090915.141606.134994761.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: yi.zhu@intel.com, mel@csn.ul.ie, reinette.chatre@intel.com,
       elendil@planet.nl, Larry.Finger@lwfinger.net, linville@tuxdriver.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       assaf.krauss@intel.com, mohamed.abbas@intel.com, netdev@vger.kernel.org
Subject: Re: alloc skb based on a given data buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253028631.23427.55.camel@johannes.local>
References: <20090915.020903.93643290.davem@davemloft.net>
	<1253006111.7549.61.camel@debian>
	<1253028631.23427.55.camel@johannes.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Sep 2009 08:30:31 -0700

> Hold, mac80211 can't cope with that at this point for sw crypto and
> possibly other things.

Then it should skb_linearize() at input, or similar.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYDNHqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYDNHqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYDNHq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:46:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34964
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbYDNHqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:46:25 -0400
Date: Mon, 14 Apr 2008 00:46:26 -0700 (PDT)
Message-Id: <20080414.004626.161082224.davem@davemloft.net>
To: kaber@trash.net
Cc: xemul@openvz.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, netdev@vger.kernel.org, andy@greyhouse.net
Subject: Re: 2.6.25-rc9: Reported regressions from 2.6.24
From: David Miller <davem@davemloft.net>
In-Reply-To: <48026AAE.8040500@trash.net>
References: <480262E9.4030500@trash.net>
	<480267C0.6020402@trash.net>
	<48026AAE.8040500@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 13 Apr 2008 22:18:54 +0200

> [BRIDGE]: Fix crash in __ip_route_output_key with bridge netfilter
> 
> The bridge netfilter code attaches a fake dst_entry with a pointer to a
> fake net_device structure to skbs it passes up to IPv4 netfilter. This
> leads to crashes when the skb is passed to __ip_route_output_key when
> dereferencing the namespace pointer.
> 
> Since bridging can currently only operate in the init_net namespace,
> the easiest fix for now is to initialize the nd_net pointer of the
> fake net_device struct to &init_net.
> 
> Should fix bugzilla 10323: http://bugzilla.kernel.org/show_bug.cgi?id=10323
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Even though we don't have a test report back yet, I've applied this,
thanks Patrick.

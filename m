Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZCWBcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZCWBcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZCWBcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:32:21 -0400
Received: from waste.org ([66.93.16.53]:38849 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZCWBcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:32:20 -0400
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
From: Matt Mackall <mpm@selenic.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, stable@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49C61AAA.8050507@gmail.com>
References: <49C61AAA.8050507@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 20:20:58 -0500
Message-Id: <1237771258.4231.134.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-22 at 12:02 +0100, Marcin Slusarz wrote:
> When ndo_open (eg skge_up) function printks something, netconsole decides
> it can use this device because it checks state only (netif_running) which is
> set before ndo_open. Check device flags too.

That's fairly unfortunate semantics for netif_running. But if Dave
agrees that it's reasonable for that to be set to true at this point in
time, then I guess we'll go with it.

-- 
http://selenic.com : development and support for Mercurial and Linux



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYDJJcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYDJJcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYDJJcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:32:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45645
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbYDJJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:32:08 -0400
Date: Thu, 10 Apr 2008 02:32:08 -0700 (PDT)
Message-Id: <20080410.023208.161440301.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-2.6.26] [IPV6] Remove unused declarations in
 include/net/ip6_route.h.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0804011145na2b25bdo4cbe7f45457b1e1c@mail.gmail.com>
References: <eb3ff54b0804011145na2b25bdo4cbe7f45457b1e1c@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Tue, 1 Apr 2008 21:45:15 +0300

> Hi,
>   This patches removes unused declarations in include/net/ip6_route.h
> 	
> 	1) Standlaone ip6_null_entry is no longer needed as it is replaced by
> 	the ip6_null_entry member of ipv6 (instance of struct netns_ipv6)	in
> 	struct net (as a result of Network Namespaces patches).
> 	
> 	
> 	2) These 3 methods from this same header are not defined anywhere:
> 	   ip6_rt_addr_add(), ip6_rt_addr_del(), rt6_sndmsg()
>
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied, thanks.

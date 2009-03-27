Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZC0HS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZC0HS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZC0HSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:18:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44208
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZC0HSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:18:42 -0400
Date: Fri, 27 Mar 2009 00:18:30 -0700 (PDT)
Message-Id: <20090327.001830.126379447.davem@davemloft.net>
To: jesper.nilsson@axis.com
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mikael.starvik@axis.com
Subject: Re: ipv6: Plug sk_buff leak in ipv6_rcv (net/ipv6/ip6_input.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326123853.GW31562@axis.com>
References: <20090326123853.GW31562@axis.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>
Date: Thu, 26 Mar 2009 13:38:53 +0100

> Commit 778d80be52699596bf70e0eb0761cf5e1e46088d
> (ipv6: Add disable_ipv6 sysctl to disable IPv6 operaion on specific interface)
> seems to have introduced a leak of sk_buff's for ipv6 traffic,
> at least in some configurations where idev is NULL, or when ipv6
> is disabled via sysctl.
 ...
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Applied and queued up for -stable, thanks!

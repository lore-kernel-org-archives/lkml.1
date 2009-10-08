Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZJHFkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZJHFkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZJHFkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:40:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44507
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbZJHFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:40:40 -0400
Date: Wed, 07 Oct 2009 22:40:36 -0700 (PDT)
Message-Id: <20091007.224036.247820677.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: thomas@wytron.com.tw, netdev@vger.kernel.org,
       thierry.reding@avionic-design.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ACD585B.5080106@gmail.com>
References: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>
	<4ACD585B.5080106@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 08 Oct 2009 05:11:23 +0200

> David, maybe we should add following helper :
> 
> [PATCH] net: Add netdev_alloc_skb_ip_align() helper
> 
> Instead of hardcoding NET_IP_ALIGN stuff in various network drivers, we can
> add a helper around netdev_alloc_skb()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks ok, but I want to look at how often this exact sequence
would match.  If it applies to a lot of cases, I'll add this
but I know of many exceptions in my head already :-)

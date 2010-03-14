Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936025Ab0CNATG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 19:19:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50739
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759415Ab0CNATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 19:19:04 -0500
Date: Sat, 13 Mar 2010 16:19:23 -0800 (PST)
Message-Id: <20100313.161923.106760717.davem@davemloft.net>
To: henne@nachtwindheim.de
Cc: herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH]: CONFIG_BRIDGE_IGMP_SNOOPING must depend on
 CONFIG_INET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268514611-7930-1-git-send-email-henne@nachtwindheim.de>
References: <[PATCH]:_CONFIG_BRIDGE_IGMP_SNOOPING_must_depend_on_CONFIG_INET>
	<1268514611-7930-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Date: Sat, 13 Mar 2010 22:10:11 +0100

> Linking the kernel fails with the the following error message,
> if CONFIG_BRIDGE_IGMP_SNOOPING is set and CONFIG_INET is not set.
> 
> net/built-in.o: In function `br_multicast_alloc_query':
> br_multicast.c:(.text+0x52045): undefined reference to `ip_send_check'
> 
> This patch is tested.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

This has been fixed for some time in the net-2.6 tree
and now Linus just pulled that tree in so his tree
has the fix too.

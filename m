Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbZHQXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbZHQXAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZHQXAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:00:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46444
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbZHQXA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:00:29 -0400
Date: Mon, 17 Aug 2009 16:00:41 -0700 (PDT)
Message-Id: <20090817.160041.40869355.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       akpm@linux-foundation.org, nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A89BF90.5070202@oracle.com>
References: <4A89BF90.5070202@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 17 Aug 2009 13:37:36 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix trace_skb_sources build when CONFIG_NET is not enabled:
> 
> kernel/built-in.o: In function `probe_skb_dequeue':
> trace_skb_sources.c:(.text+0xd9152): undefined reference to `init_net'
> trace_skb_sources.c:(.text+0xd9188): undefined reference to `dev_get_by_index'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.

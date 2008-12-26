Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYLZT7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYLZT7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYLZT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:59:29 -0500
Received: from xenotime.net ([72.52.64.118]:45623 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752414AbYLZT72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:59:28 -0500
Date: Fri, 26 Dec 2008 11:59:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Miller <davem@davemloft.net>
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/27] drivers/net: fix sparse warning: returning
 void-valued expression
Message-Id: <20081226115921.bb094c58.rdunlap@xenotime.net>
In-Reply-To: <20081225.161740.10052019.davem@davemloft.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191517.11807.20718.stgit@vmbox.hanneseder.net>
	<20081225.161740.10052019.davem@davemloft.net>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Dec 2008 16:17:40 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Hannes Eder <hannes@hanneseder.net>
> Date: Mon, 22 Dec 2008 20:15:17 +0100
> 
> > Fix this sparse warning:
> > 
> >   drivers/net/niu.c:8850:2: warning: returning void-valued expression
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> 
> Can we just fix sparse not to generate this warning?  It's
> marginal, at best.  C++ even explicitly defines this as valid
> and last time I brought this up Linus even agreed.

Ack, I discussed it with him also and he thought that
they were just fine as they were...

> The types match, the function returns void and it is returning a void,
> what is the problem?


-- 
~Randy

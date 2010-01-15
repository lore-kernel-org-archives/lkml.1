Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0AOJJK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824Ab0AOJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:09:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58490
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672Ab0AOJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:09:07 -0500
Date: Fri, 15 Jan 2010 01:09:16 -0800 (PST)
Message-Id: <20100115.010916.104760167.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/core/sock.c: quiet sparse noise
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001141721.45305.hartleys@visionengravers.com>
References: <201001141721.45305.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Thu, 14 Jan 2010 17:21:45 -0700

> net/core/sock.c: quiet sparse noise
> 
> In sock_getsockopt the symbol 'lv' is declared as an
> unsigned int type, probably due to sizeof returning a
> size_t which is really an unsigned int.
> 
> This produces a sparse warning for SO_PEERNAME due to
> the sock->ops->getname() call:
> 
> warning: incorrect type in argument 3 (different signedness)
>    expected int *sockaddr_len
>    got unsigned int *<noident>
> 
> Quiet the warning my changing the type of 'lv' to an int.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied to net-next-2.6, thanks.

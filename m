Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbXFXGGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbXFXGGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 02:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXFXGGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 02:06:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbXFXGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 02:06:44 -0400
Date: Sat, 23 Jun 2007 23:07:02 -0700 (PDT)
Message-Id: <20070623.230702.60547745.davem@davemloft.net>
To: konstantin.sharlaimov@gmail.com
Cc: paulus@samba.org, vsu@altlinux.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 2.6.21.5] ppp: fix osize too small errors when
 decoding mppe
From: David Miller <davem@davemloft.net>
In-Reply-To: <4679116E.9050507@gmail.com>
References: <4679116E.9050507@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Date: Wed, 20 Jun 2007 22:37:18 +1100

> The mppe_decompress() function required a buffer that is 1 byte too small when
> receiving a message of mru size. This fixes buffer allocation to prevent this
> from occurring.
> 
> Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>

This looks better, I've reverted the original version of the
fix and applied this new one.

> --- linux-2.6.21.3/drivers/net/ppp_generic.c.orig	2007-06-20 09:14:13.000000000
> +1100
> +++ linux-2.6.21.3/drivers/net/ppp_generic.c	2007-06-20 09:18:06.000000000 +1100

Please prevent your email client from corrupting patches like
this by adding new lines.

I've fixed up your patches by hand now twice, I'm not going to do it
any more.

Thanks.

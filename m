Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYKFE0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYKFE0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYKFEZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:25:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYKFEZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:25:58 -0500
Date: Wed, 05 Nov 2008 20:25:57 -0800 (PST)
Message-Id: <20081105.202557.233628145.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
Subject: Re: tty warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
References: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Nov 2008 15:24:21 +1100

> These are things like:
> 
>                 termios->c_cc[VTIME] = 0;
> 
> termios is a (struct ktermios *) which has "cc_t c_cc[NCCS];".  NCCS is
> 17 and VTIME is also 17.  I assume the intention is to actually fill in
> _x_cc[0], but why is it done this way and not more directly?

It's just some historical stuff.

I've tried to rectify it, but it is non-trivial to fix and
all it does is pacify a warning rather than fix a real problem
so... ;-)

This has been brought up perhaps 5 or 6 times in the past half
year :)

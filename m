Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXJHGqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXJHGqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXJHGqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:46:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34656
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbXJHGqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:46:14 -0400
Date: Sun, 07 Oct 2007 23:46:06 -0700 (PDT)
Message-Id: <20071007.234606.111182047.davem@davemloft.net>
To: den@sw.ru
Cc: herbert@gondor.apana.org.au, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, den@openvz.org
Subject: Re: [NET] IPv6 oops bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <4709CF6F.60102@sw.ru>
References: <20071008061942.GA842@gondor.apana.org.au>
	<20071007.232302.78733656.davem@davemloft.net>
	<4709CF6F.60102@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@sw.ru>
Date: Mon, 08 Oct 2007 10:34:23 +0400

> OK. I am installing Fedora 7 right now...

You don't need to install Fedora, just read the code! :-)

The bug is obvious and it's been explained thoroughly in this
thread.

When 'dev' is NULL in ip6_route_add() we need to figure out what
namespace and/or loopback device you want to use.

There is no reason to do an entire dist install to work on fixing this
bug, yikes!

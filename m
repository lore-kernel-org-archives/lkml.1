Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZGFUIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZGFUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZGFUIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:08:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34918
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbZGFUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:08:39 -0400
Date: Mon, 06 Jul 2009 13:08:41 -0700 (PDT)
Message-Id: <20090706.130841.109675901.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       abacabadabacaba@gmail.com, maxk@qualcomm.com, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: tun/tap crashes if open() /dev/net/tun and then
 poll() it.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090706074835.3fe641f0@mako-desktop>
References: <20090706001114.2d4517be@mako-desktop>
	<20090706011230.GC15156@gondor.apana.org.au>
	<20090706074835.3fe641f0@mako-desktop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Mon, 6 Jul 2009 07:48:35 +0200

> Fix NULL pointer dereference in tun_chr_pool() introduced by
> commit 33dccbb050bbe35b88ca8cf1228dcf3e4d4b3554 and triggered
> by this code:
> 
> 	int fd;
> 	struct pollfd pfd;
> 	fd = open("/dev/net/tun", O_RDWR);
> 	pfd.fd = fd;
> 	pfd.events = POLLIN | POLLOUT;
> 	poll(&pfd, 1, 0);
> 
> Reported-by: Eugene Kapun <abacabadabacaba@gmail.com>
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied, thanks!

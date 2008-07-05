Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYGELdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYGELdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYGELdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:33:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34341 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYGELda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:33:30 -0400
Date: Sat, 5 Jul 2008 13:33:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Anvin <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: the printk problem
In-Reply-To: <20080704150100.1f7b8a65.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0807051332200.28765@fbirervta.pbzchgretzou.qr>
References: <20080625131101.GA6205@digi.com> <20080704104634.GA31634@digi.com> <20080704111540.ddffd241.akpm@linux-foundation.org> <alpine.LFD.1.10.0807041147450.2815@woody.linux-foundation.org> <alpine.LFD.1.10.0807041250220.2815@woody.linux-foundation.org>
 <20080704132716.f1e12554.akpm@linux-foundation.org> <20080704204252.GM14894@parisc-linux.org> <20080704150100.1f7b8a65.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-07-05 00:01, Andrew Morton wrote:
>
>We don't know how much interest there would be in churning NIPQUAD from
>the net guys.  Interestingly, there's also %C (wint_t) which is a
>32-bit quantity.  So we could just go and say "%C prints an ipv4
>address" and be done with it.  But there's no way of doing that for
>ipv6 addresses so things would become asymmetrical there.

	struct in6_addr src;
	printk("Source address: %p{ipv6}\n", &src);

How about %p{feature}?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbXLESmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbXLESmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXLESmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:42:33 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:20269 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXLESmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:42:32 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zXqM8wH
From: Stefan Rompf <stefan@loplof.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Wed, 5 Dec 2007 19:39:07 +0100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <4755A21F.2020407@simon.arlott.org.uk> <20071204.223023.262159049.davem@davemloft.net> <20071205065132.GA11476@gondor.apana.org.au>
In-Reply-To: <20071205065132.GA11476@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712051939.08384.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2007 07:51 schrieb Herbert Xu:

> > If he sets this sysctl to "1" as I detailed in my reply, he'll
> > get the behavior he wants.
>
> Does anybody actually need the 0 setting? What would we break if
> the default became 1?

I'd strongly suggest doing so. AFAIK, behaviour of connect() on nonblocking 
sockets is quite well defined in POSIX. If this is changed for some IP 
sockets, event-driven applications will randomly and subtly break.

Stefan

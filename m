Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYLGRZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYLGRZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYLGRYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:24:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbYLGRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:24:53 -0500
Date: Sun, 7 Dec 2008 17:24:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207172447.3ff2d58f@lxorguk.ukuu.org.uk>
In-Reply-To: <20081207170349.GA472@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com>
	<20081207165740.2c4bbb0d@lxorguk.ukuu.org.uk>
	<20081207170349.GA472@ioremap.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Heh, init is not allowed to write something to the console or any other
> tty?

init is not run as the helper of a modprobe.

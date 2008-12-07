Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYLGQL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYLGQL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYLGQLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:11:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32800 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754179AbYLGQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:11:19 -0500
Date: Sun, 7 Dec 2008 16:09:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, zbr@ioremap.net,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207160921.693f637a@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
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

> Even when this works around it, the problem that the kernel triggers
> module loading on /dev/console access stays and needs to be fixed
> instead.

It isn't a problem. It is trying to have hotplug load a suitable driver.
This is what is supposed to happen.

Alan

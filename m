Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYLGPQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYLGPQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYLGPQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:16:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59496 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbYLGPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:16:06 -0500
Date: Sun, 7 Dec 2008 15:14:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kay.sievers@vrfy.org, zbr@ioremap.net, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207151408.7fa1fead@lxorguk.ukuu.org.uk>
In-Reply-To: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
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

> In any case the loop itself does not involve any crypto components
> so I don't think making changes in the crypto layer is going to
> make this go away forever as anyone calling request_module early
> enough will get into this loop.

Thanks - closed as WONTFIX as this is ultimately a user space bug caused
by picking particularly odd combinations of configuration options (serial
console, crypto testing) combined with a problem with someones specific
initrd

Alan

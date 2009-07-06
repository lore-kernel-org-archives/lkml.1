Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZGFHz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZGFHz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZGFHzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:55:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60924 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753168AbZGFHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:55:51 -0400
Date: Mon, 6 Jul 2009 15:55:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: sergey.senozhatsky@mail.by, rabin@rab.in, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090706075522.GA17653@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622133612.22fd84b8@lxorguk.ukuu.org.uk>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> Just delete the tty_unthrottle() from drivers/net/ppp/ppp_async.c - it
> never throttles the port so it never needs to unthrottle it (which is why
> it happened never to cause crashes before)

I'm not sure about that.  The PTY driver is always in the throttled
state, so tty_unthrottle isn't a noop.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

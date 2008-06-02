Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYFBGUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYFBGUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBGUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:20:23 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:37998 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbYFBGUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:20:23 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ilpo.jarvinen@helsinki.fi (Ilpo J??rvinen)
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: johnpol@2ka.mipt.ru, ray-lk@madrabbit.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net, rjw@sisk.pl, akpm@linux-foundation.org
Organization: Core
In-Reply-To: <Pine.LNX.4.64.0805311044360.2189@wrl-59.cs.helsinki.fi>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1K33OH-0005QX-00@gondolin.me.apana.org.au>
Date: Mon, 02 Jun 2008 16:19:33 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo J??rvinen <ilpo.jarvinen@helsinki.fi> wrote:
>
> Before:
> tcp    65436      0 lo:5000          lo:59980         ESTABLISHED -

This is what happens before accept(2) is called.  Ingo, please
strace the process that owns the listening socket to make sure
that it is actually calling accept(2).  If it ever stops calling
accept(2) then this is expected behaviour.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

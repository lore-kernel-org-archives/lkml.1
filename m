Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYGIF6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYGIF6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 01:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYGIF6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 01:58:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:53460 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbYGIF6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 01:58:35 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kyle@mcmartin.ca (Kyle McMartin)
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Cc: alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, kmcmartin@redhat.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <20080708193741.GB28899@phobos.i.cabal.ca>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KGSh3-0002uS-00@gondolin.me.apana.org.au>
Date: Wed, 09 Jul 2008 13:58:21 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@mcmartin.ca> wrote:
> 
> I completely agree, but I don't know anything about Centaur cpuids...
> 
> Something like this might suffice:

Please base your patch on top of cryptodev-2.6 which already has
a fix on this from Jeremy Katz.  Also I suggest you either remove
the printk completely or invert it so that it prints something
when the hardware is detected.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

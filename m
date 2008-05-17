Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYEQTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYEQTyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYEQTyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:54:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9884 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYEQTyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:54:03 -0400
Message-ID: <a24804730805171254i2a37da61mb47280db7b330ed5@mail.gmail.com>
Date: Sat, 17 May 2008 12:54:02 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net
In-Reply-To: <482EBAA8.3040506@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080515142154.0595e475@core> <482C7DA3.1090809@garzik.org>
	 <482C953A.4080205@garzik.org> <87abirytxj.fsf@basil.nowhere.org>
	 <20080516105635.6cb1f505@core> <482D5FC5.2070103@firstfloor.org>
	 <20080516121239.GA9627@gondor.apana.org.au>
	 <482DB568.1040704@firstfloor.org>
	 <20080517010136.GA15102@gondor.apana.org.au>
	 <482EBAA8.3040506@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would people be ok with kernel auto-feeding for /dev/urandom only? I've
> been pondering that and I think that would work just as well in practice
>  given the facts above. Then you would still only get blocking
> /dev/random with the user daemon, but that won't matter because all
> the usual users don't rely on thatanyways.

Andi, can you please clarify what you mean by "auto-feeding
/dev/urandom only" and "only get blocking /dev/random with the user
daemon"? Are you suggesting that the kernel provides /dev/urandom and
a userspace daemon (e.g. EGD) provides /dev/random?

Also, if crypto apps like ssh and openssl use on "insecure"
/dev/urandom, then who actually relies on /dev/random? For comparison,
FreeBSD does not even (AFAIK) have /dev/urandom. FreeBSD's /dev/random
is nonblocking (like Linux's /dev/urandom) and includes network
entropy.


chris

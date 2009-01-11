Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZAKLUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZAKLUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZAKLUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:20:34 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:39337 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbZAKLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:20:33 -0500
Date: Sun, 11 Jan 2009 22:20:19 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulus@samba.org
Cc: gorcunov@gmail.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 4/4] net: ppp_generic - introduce net-namespace
	functionality
Message-ID: <20090111112019.GA29691@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> wrote:
> 
> This looks like a lot of uglification to me.  Why exactly do
> individual network drivers need to know or care about namespaces?

I think ppp is special because it's closer to the tunnel drivers
than a straight NIC driver which is why it needs this work.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

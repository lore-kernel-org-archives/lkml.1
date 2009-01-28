Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZA1JIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZA1JIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZA1JI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:08:29 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53020 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbZA1JI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:08:28 -0500
Date: Wed, 28 Jan 2009 20:08:21 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: hardware time stamping with optional structs in data area
Message-ID: <20090128090821.GA15770@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233069837.24438.54.camel@pohly-MOBL>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ohly <patrick.ohly@intel.com> wrote:
>
> True - at this time. But what if this extension mechanism turns out to
> be useful and we end up with more optional structures? I was hoping that
> this might be the case and thus tried to make it easy to add more
> structures.

You're putting the extension in the skb->end area, right?

How big are the time stamps? If they're not that big, why don't
we put it into the shinfo structure itself? For the common case,
we have plenty of space due to kmalloc padding anyway.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

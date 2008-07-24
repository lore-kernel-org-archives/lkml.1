Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYGXLNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYGXLNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYGXLNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:13:23 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:52894 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbYGXLNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:13:23 -0400
Date: Thu, 24 Jul 2008 19:12:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: w@1wt.eu, davem@davemloft.net, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
Message-ID: <20080724111231.GA6485@gondor.apana.org.au>
References: <20080724060448.GA10203@elte.hu> <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au> <20080724092517.GA31358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724092517.GA31358@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:25:18AM +0200, Ingo Molnar wrote:
>
> without rebooting the kernel, right? And then if the bug comes back 
> again we've nailed it down to the area you suspect, correct?

Yes, except that you'll have to reestablish those connections
to make the new setting take effect.  In either case please
verify with tcpdump to make sure that both sides are proposing
sack at the start of the connection.  Alternatively see whether
sacks are generated in case of packet loss.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

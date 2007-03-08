Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbXCHLDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbXCHLDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXCHLDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:03:15 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1435 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbXCHLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:03:13 -0500
Date: Thu, 8 Mar 2007 22:02:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: simon@arlott.org, linux-kernel@vger.kernel.org, sri@us.ibm.com,
       netdev@vger.kernel.org, lksctp-developers@lists.sourceforge.net
Subject: Re: [PATCH][SCTP] Re: lockdep: inconsistent lock state ipv6_add_addr/sctp_v6_copy_addrlist (2.6.21-rc1)
Message-ID: <20070308110230.GA9175@gondor.apana.org.au>
References: <20070308074751.GA2085@ff.dom.local> <E1HPGMB-0002AG-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HPGMB-0002AG-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 10:00:23PM +1100, Herbert Xu wrote:
> 
> Who's calling ipv6_add_addr from softirq context? That's got to be
> wrong because ipv6_add_addr requires the RTNL.

Nevermind, I was thinking of ipv6_add_dev.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

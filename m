Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXLRDdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXLRDdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXLRDdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:33:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3674 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbXLRDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:33:38 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: cfriesen@nortel.com (Chris Friesen)
Subject: Re: "ip neigh show" not showing arp cache entries?
Cc: yoshfuji@linux-ipv6.org, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <476696A5.1010101@nortel.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J4TCz-0005L8-00@gondolin.me.apana.org.au>
Date: Tue, 18 Dec 2007 11:33:29 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen <cfriesen@nortel.com> wrote:
>
> However, if I specifically try to print out one of the missing entries, 
> it shows up:
> 
> root@typhoon-base-unit0:/root> /tmp/ip neigh show 192.168.24.81
> 192.168.24.81 dev bond2 lladdr 00:01:af:14:e9:8a REACHABLE

What about

	ip -4 neigh show

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

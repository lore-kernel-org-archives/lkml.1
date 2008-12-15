Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYLOVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYLOVxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYLOVxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:53:33 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42151 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755640AbYLOVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:53:32 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: patrick.ohly@intel.com (Patrick Ohly)
Subject: Re: [RFC PATCH 02/12] net: infrastructure for hardware time stamping
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
       johnstul@us.ibm.com, linux-api@vger.kernel.org, patrick.ohly@intel.com
Organization: Core
In-Reply-To: <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LCLNV-0001EW-CN@gondolin.me.apana.org.au>
Date: Tue, 16 Dec 2008 08:53:25 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ohly <patrick.ohly@intel.com> wrote:
> @@ -305,6 +406,8 @@ struct sk_buff {
>                                ipvs_property:1,
>                                peeked:1,
>                                nf_trace:1;
> +       /* not all of the bits in optional are used */
> +       __u8                    optional;
>        __be16                  protocol;

You do reliase that this is going to grow the sk_buff by at least
4 bytes and not 1?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

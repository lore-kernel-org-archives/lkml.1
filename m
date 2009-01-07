Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZAGMpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZAGMpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZAGMpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:45:06 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46575 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753807AbZAGMpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:45:05 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: w@1wt.eu (Willy Tarreau)
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Cc: jarkao2@gmail.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20090106155715.GA28783@1wt.eu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LKXmG-0006nY-14@gondolin.me.apana.org.au>
Date: Wed, 07 Jan 2009 23:44:52 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> wrote:
> 
> root@wtap:~# ethtool -k eth0
> Offload parameters for eth0:
> rx-checksumming: off
> tx-checksumming: off
> scatter-gather: off
> tcp segmentation offload: off

Can you please upgrade your ethtool so that it knows about GSO?
Once you've done that please retest with everything including
GSO turned off.

Alternatively edit out the bit that enables GSO by default in
net/core/dev.c.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

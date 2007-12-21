Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXLUMOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXLUMOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXLUMNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:13:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4513 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756448AbXLUMNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:13:22 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: rusty@rustcorp.com.au (Rusty Russell)
Subject: Re: [PATCH 0/5] sg_ring for scsi
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, dougg@torque.net
Organization: Core
In-Reply-To: <200712211013.38511.rusty@rustcorp.com.au>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.scsi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J5gkV-0000Ig-00@gondolin.me.apana.org.au>
Date: Fri, 21 Dec 2007 20:13:07 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> 2) It allows others to manipulate sg chains, which couldn't be done before
>   (eg. the ATA code which wants to append a padding element).

Yes chaining at the end is very useful for the crypto layer as
well.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

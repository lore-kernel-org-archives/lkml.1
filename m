Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbXLNLrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbXLNLrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXLNLq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:46:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1397 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbXLNLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:46:58 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org (Andrew Morton)
Subject: Re: BUG: file descriptors leak when sys_pipe failed with -EFAULT
Cc: xiaosuo@gmail.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Organization: Core
In-Reply-To: <20071213132148.8f18a107.akpm@linux-foundation.org>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J390D-0004Xr-00@gondolin.me.apana.org.au>
Date: Fri, 14 Dec 2007 19:46:49 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
>
> The consequences of this are that the application may eventually run out of
> file descriptors and they will be cleaned up when the application exits
> anyway, so it isn't terribly serious.

If an application is calling pipe(2) with bogus pointers then
leaving open file descriptors behind is the least of its worries.
So I think fixing this is really a waste of time.  But whatever.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

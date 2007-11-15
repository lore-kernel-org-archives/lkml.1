Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXKOGep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXKOGep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXKOGb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:31:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2632 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932089AbXKOGbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:31:25 -0500
Date: Thu, 15 Nov 2007 14:29:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
Message-ID: <20071115062939.GA23579@gondor.apana.org.au>
References: <20071115055238.692814352@mini.kroah.org> <20071115062022.GG8282@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115062022.GG8282@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:20:22PM -0800, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> patch deea84b0ae3d26b41502ae0a39fe7fe134e703d0 in mainline.
> 
> [NET]: Fix SKB_WITH_OVERHEAD calculation

Although this is correct as it is, it tirggers a latent bug
which is fixed by

commit fb93134dfc2a6e6fbedc7c270a31da03fce88db9
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Nov 14 15:45:21 2007 -0800

    [TCP]: Fix size calculation in sk_stream_alloc_pskb

So please postpone it to the next round such that both patches
can be included together.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

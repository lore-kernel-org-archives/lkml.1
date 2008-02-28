Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYB1Tap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYB1Tap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761803AbYB1Tad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:30:33 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51564 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbYB1Tad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:30:33 -0500
Date: Fri, 29 Feb 2008 03:30:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: Daniel.Beschorner@facton.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: zlib oops with ipcomp in 2.6.24
Message-ID: <20080228193019.GA18514@gondor.apana.org.au>
References: <20080223000328.3a71e858.akpm@linux-foundation.org> <3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local> <20080228175011.GA17185@gondor.apana.org.au> <20080228.112355.15717375.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228.112355.15717375.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:23:55AM -0800, David Miller wrote:
> 
> The xfrm output lockless stuff is only in 2.6.25, so
> we should not need this for -stable right?

Actually this particular bug is in 2.6.24 too so we need it
there.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

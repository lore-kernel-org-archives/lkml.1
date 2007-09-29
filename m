Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXI2Aze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXI2Aze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXI2AzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:55:23 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1484 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755915AbXI2AzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:55:21 -0400
Date: Sat, 29 Sep 2007 08:55:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Module use count must be updated as bridges are created/destroyed
Message-ID: <20070929005513.GB31959@gondor.apana.org.au>
References: <46FBE2DD.76E4.0078.0@novell.com> <E1Ib8Xj-0006Kl-00@gondolin.me.apana.org.au> <20070928111107.57519b67@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928111107.57519b67@freepuppy.rosehill>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:11:07AM -0700, Stephen Hemminger wrote:
>
> It is only the nested removal problem.

Well such a count could apply to direct removals too.  In other
words, you could ask modprobe to remove all modules for which
this count is zero.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

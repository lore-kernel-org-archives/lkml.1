Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbZJ1HZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbZJ1HZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbZJ1HZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:25:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932505AbZJ1HZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:25:57 -0400
Date: Wed, 28 Oct 2009 15:25:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when
	checking whether copying is required
Message-ID: <20091028072559.GA15131@gondor.apana.org.au>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 07:25:33PM -0400, Chuck Ebbert wrote:
> crypto: padlock-aes: Use the correct mask when checking whether copying is required
> 
> Masking with PAGE_SIZE is just wrong... and there's no need for the braces and return

Thanks for the patch, that does indeed look wrong.

> statement either.

But can we please keep unrelated stylistic changes in a separate
patch? In this case I'm not even sure that it is better than the
original.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

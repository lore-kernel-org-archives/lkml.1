Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYJLMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYJLMlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYJLMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:41:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50467 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbYJLMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:41:05 -0400
Date: Sun, 12 Oct 2008 20:40:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Carlo E. Prelz" <fluido@fluido.as>, Tomoyuki Okazaki <okazaki@kick.gr.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: use kernel-provided bitops, unaligned access
Message-ID: <20081012124042.GA14397@gondor.apana.org.au>
References: <1222409882.7795.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222409882.7795.20.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 11:18:02PM -0700, Harvey Harrison wrote:
> Remove the private implementation of 32-bit rotation and unaligned
> access with byteswapping.
> 
> As a bonus, fixes sparse warnings:
> crypto/camellia.c:602:2: warning: cast to restricted __be32
> crypto/camellia.c:603:2: warning: cast to restricted __be32
> crypto/camellia.c:604:2: warning: cast to restricted __be32
> crypto/camellia.c:605:2: warning: cast to restricted __be32
> crypto/camellia.c:710:2: warning: cast to restricted __be32
> crypto/camellia.c:711:2: warning: cast to restricted __be32
> crypto/camellia.c:712:2: warning: cast to restricted __be32
> crypto/camellia.c:713:2: warning: cast to restricted __be32
> crypto/camellia.c:714:2: warning: cast to restricted __be32
> crypto/camellia.c:715:2: warning: cast to restricted __be32
> crypto/camellia.c:716:2: warning: cast to restricted __be32
> crypto/camellia.c:717:2: warning: cast to restricted __be32
> 
> [Thanks to Tomoyuki Okazaki for spotting the typo]
> Tested-by: Carlo E. Prelz <fluido@fluido.as>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZFAMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZFAMeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZFAMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:34:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35424 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753275AbZFAMeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:34:03 -0400
Date: Mon, 1 Jun 2009 22:33:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, riel@redhat.com, research@subreption.com,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu, linux-mm@kvack.org,
       torvalds@osdl.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
	key/iv handling
Message-ID: <20090601123342.GA13261@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601085814.3e010533@lxorguk.ukuu.org.uk>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> Zeroing long term keys makes sense but for the short lifepsan keys used on
> the wire its a bit pointless irrespective of speed (I suspect done
> properly the performance impact would be close to nil anyway)

Sure, though we're not actually arguing whether keys should be
zeroed here, but the metadata, i.e., pointers to keys, buffers,
etc.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbZFAEtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbZFAEtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZFAEtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:49:00 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39062 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185AbZFAEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:48:59 -0400
Date: Mon, 1 Jun 2009 14:48:37 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: riel@redhat.com, research@subreption.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
       alan@lxorguk.ukuu.org.uk, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
	key/iv handling
Message-ID: <20090601044837.GA9220@gondor.apana.org.au>
References: <20090531025720.GC9033@oblivion.subreption.com> <20090530.230213.73434433.davem@davemloft.net> <4A22967C.3080304@redhat.com> <20090531.214623.76344831.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531.214623.76344831.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 09:46:23PM -0700, David Miller wrote:
> 
> I don't even want to think about what this does to IPSEC rule creation
> rates, that that matters heavily for cell phone networks where
> hundreds of thousands of nodes come in and out of the server and each
> such entry requires creating 4 IPSEC rules.

I completely agree.  The zeroing of metadata is gratuitous.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

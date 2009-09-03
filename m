Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZICDW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZICDW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 23:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZICDW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 23:22:27 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42344 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754130AbZICDW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 23:22:27 -0400
Date: Thu, 3 Sep 2009 13:22:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jonas Meurer <jonas@freesources.org>
Cc: sebastian@breakpoint.cc, celejar@gmail.com, randy.dunlap@oracle.com,
       541835@bugs.debian.org, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, control@bugs.debian.org
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Message-ID: <20090903032206.GA18883@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901005120.GB22049@resivo.wgnet.de>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Meurer <jonas@freesources.org> wrote:
> 
> i guess the best solution would be to improve the module dependency
> system. cipher meta-modules like 'aes' should depend on all available
> implementations. same for ivciphers, hashs, rng implementations etc.

We already do that for algorithms at least, they should all have
aliases of the form "ALG" or "ALG-all".

Things like chainiv/eseqiv should just be included always.  There
are unlikely to be any new algorithms of that type.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

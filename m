Return-Path: <linux-kernel-owner+w=401wt.eu-S1161054AbXAaWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054AbXAaWAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161056AbXAaWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:00:32 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3293 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161054AbXAaWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:00:31 -0500
Date: Thu, 1 Feb 2007 08:59:47 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Valdis.Kletnieks@vt.edu
Cc: wsl3@lrsehosting.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alan@redhat.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: Unidentified Intel wifi network card
Message-ID: <20070131215947.GA28294@gondor.apana.org.au>
References: <1170264624.5569.15.camel@scott-640m> <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 03:54:55PM -0500, Valdis.Kletnieks@vt.edu wrote:
> 
> Oh - the git-crypto-fix patch has to be applied with -R, I never got around to
> re-diffing it the other way.

If this driver is still using the old digest interface, it needs to be
converted to use crypto_hash_*.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZFRJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZFRJce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZFRJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:32:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58839 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbZFRJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:32:26 -0400
Date: Thu, 18 Jun 2009 17:32:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [patch 1/2] crypto: padlock-aes: work around Nano CPU errata
	in ECB mode
Message-ID: <20090618093224.GA5145@gondor.apana.org.au>
References: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com> <20090618092309.GT7692@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618092309.GT7692@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 11:23:09AM +0200, Harald Welte wrote:
> Hi Herbert,
> 
> do you think we will still be able to get this Nano errata handling
> into 2.6.31?  I've noticed that crpyto-2.6 and cryptodev-2.6 also don't seem
> to have those patches.  Are there any issues?  I would want to help in case
> there is any to-be-resolved issues with this patchset.
> 
> Once we have it in mainline, I woul also ask about your opinion on whether
> you think they're applicable for the -stable series.

Don't worry, I'll send them off to crypto-2.6 followed by stable.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

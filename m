Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbZFRLgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbZFRLgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZFRLgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:36:01 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:37909 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbZFRLgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:36:01 -0400
Date: Thu, 18 Jun 2009 19:35:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Harald Welte <HaraldWelte@viatech.com>, linux-kernel@vger.kernel.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [patch 1/2] crypto: padlock-aes: work around Nano CPU errata
	in ECB mode
Message-ID: <20090618113559.GA6596@gondor.apana.org.au>
References: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 03:11:22PM -0400, Chuck Ebbert wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
> crypto: padlock-aes: work around Nano CPU errata in ECB mode
> 
> The VIA Nano processor has a bug that makes it prefetch extra data
> during encryption operations, causing spurious page faults. Extend
> existing workarounds for ECB mode to copy the data to an temporary
> buffer to avoid the problem.
> 
> Acked-by: HaraldWelte <HaraldWelte@viatech.com>
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

All applied to crypt-2.6.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

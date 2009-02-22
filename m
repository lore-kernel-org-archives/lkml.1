Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZBVEEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZBVEEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 23:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZBVEDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 23:03:54 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58191 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752660AbZBVEDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 23:03:53 -0500
Date: Sun, 22 Feb 2009 12:03:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHv3 REPOST] hw_random: add timeriomem-rng driver
Message-ID: <20090222040345.GA753@gondor.apana.org.au>
References: <20090217135130.GN32719@woodchuck> <20090217141324.GP32719@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217141324.GP32719@woodchuck>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 02:13:24PM +0000, Alexander Clouter wrote:
> Some hardware platforms, the TS-7800[1] is one for example, can
> supply the kernel with an entropy source, albeit a slow one for
> TS-7800 users, by just reading a particular IO address.  This
> source must not be read above a certain rate otherwise the quality
> suffers.

Applied to cryptodev.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

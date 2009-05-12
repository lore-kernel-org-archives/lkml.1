Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZELTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZELTIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZELTIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:08:38 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41558 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZELTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:08:37 -0400
Date: Tue, 12 May 2009 15:08:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] crypto: mark algs allowed in fips mode
Message-ID: <20090512190823.GF5019@hmsreliant.think-freely.org>
References: <200905110952.44273.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905110952.44273.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 09:52:43AM -0400, Jarod Wilson wrote:
> Set the fips_allowed flag in testmgr.c's alg_test_descs[] for algs
> that are allowed to be used when in fips mode.
> 
> One caveat: des isn't actually allowed anymore, but des (and thus also
> ecb(des)) has to be permitted, because disallowing them results in
> des3_ede being unable to properly register (see des module init func).
> 
> Also, crc32 isn't technically on the fips approved list, but I think
> it gets used in various places that necessitate it being allowed.
> 
> This list is based on
> http://csrc.nist.gov/groups/STM/cavp/index.html
> 
> Important note: allowed/approved here does NOT mean "validated", just
> that its an alg that *could* be validated.
> 
> Resending with properly updated patch v2 tag.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 

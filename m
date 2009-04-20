Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZDTGDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZDTGDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZDTGDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:03:24 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44034 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752575AbZDTGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:03:23 -0400
Date: Mon, 20 Apr 2009 14:03:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in
	crypto_{,de}compress_{update,final}() (was: Re: [PATCH/RFC] crypto:
	compress - Add comp_request.total_out (was: Re: [PATCH 6/6]
	squashfs: Make SquashFS 4 use the new pcomp crypto interface))
Message-ID: <20090420060313.GA891@gondor.apana.org.au>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be> <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 05:33:01PM +0100, Geert Uytterhoeven wrote:
> 
> Here's an alternative patch, which does exactly that.
> Phillip, what do you think?
> 
> Thanks for your comments!
> 
> >From be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Date: Tue, 24 Mar 2009 17:19:05 +0100
> Subject: [PATCH] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()
> 
> If crypto_{,de}compress_{update,final}() succeed, return the actual number of
> bytes produced instead of zero, so their users don't have to calculate that
> theirselves.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

I certainly prefer this version over the other one? Do you want to
submit crypto API portion of this?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

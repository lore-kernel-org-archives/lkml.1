Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZCJNjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZCJNjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZCJNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:38:49 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60712 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbZCJNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:38:48 -0400
Date: Tue, 10 Mar 2009 21:38:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090310133828.GA14396@gondor.apana.org.au>
References: <20090310192440.949884a1.sfr@canb.auug.org.au> <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 02:31:17PM +0100, Geert Uytterhoeven wrote:
>
> Why doesn't it work for dynamic_pr_debug()?

Because fmt is expanded twice?

> BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
> intended usage of your pr_fmt() infrastructure?

I never liked this in the first place :) If anyone wants to debug
this they can add whatever printks they want.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

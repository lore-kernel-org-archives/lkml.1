Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbXLOGey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbXLOGey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLOGes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:34:48 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2726 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbXLOGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:34:47 -0500
Date: Sat, 15 Dec 2007 14:34:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215063442.GA26491@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au> <1197700290.6696.52.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197700290.6696.52.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 05:31:30PM +1100, Benjamin Herrenschmidt wrote:
>
> That's something I've actually never quite liked... the fact that we
> evaluate the expression anyway. I'm pretty happy with -not- evaluating
> the expression when CONFIG_BUG is on most of the time since whatever is
> in there is purely here for the sake of the BUG/WARN test.

Whether we evaluate the expression is a completely different debate.
I personally agree with you that expressions that have side-effects
are a stupid idea for either WARN_ON or BUG_ON.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZCNNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZCNNYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZCNNYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:24:45 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54013 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753441AbZCNNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:24:44 -0400
Date: Sat, 14 Mar 2009 21:24:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Ingo Molnar <mingo@elte.hu>, linux-crypto@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mail@tobiasvolk.de
Subject: Re: enable padlock on x86_64
Message-ID: <20090314132420.GB6080@gondor.apana.org.au>
References: <49B83002.9040705@tobiasvolk.de> <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc> <20090314114732.GB3805@elte.hu> <20090314115307.GA28235@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314115307.GA28235@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 12:53:07PM +0100, Sebastian Andrzej Siewior wrote:
> 
> Yep, it is fine.
> #1 in, #2 not will not result in any difference to what we have now.
> #2 in, #1 not will result in "padlock not detected" while loading the
> module and -ENODEV.

Let's merge #1 right now and I'll pick up #2 once #1 shows up
in linux-net.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

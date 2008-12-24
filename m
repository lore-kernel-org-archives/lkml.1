Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbYLXWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbYLXWdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLXWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:33:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYLXWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:33:10 -0500
Date: Wed, 24 Dec 2008 14:32:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.28
In-Reply-To: <20081224222045.GA488@gondor.apana.org.au>
Message-ID: <alpine.LFD.2.00.0812241432130.3535@localhost.localdomain>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au>
 <20081210123524.GA11696@gondor.apana.org.au> <20081224222045.GA488@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Dec 2008, Herbert Xu wrote:
> 
> A regression has been reported where the new algorithm testing
> infrastructure may cause the optimised versions of AES to fail
> when it's built into the kernel (as opposed to as a module).

Can't we just get rid of that stupid testing infrastructure, or make it a 
module-only thing? I refuse to pull a 1000+ line patch for something like 
this, especially this late. It's insane.

		Linus

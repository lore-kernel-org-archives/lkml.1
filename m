Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbXETDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbXETDQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbXETDQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 23:16:10 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3820 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755675AbXETDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 23:16:09 -0400
Date: Sun, 20 May 2007 13:15:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
Message-ID: <20070520031550.GA22903@gondor.apana.org.au>
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk> <20070518064500.GA16394@gondor.apana.org.au> <464F4FD1.5030308@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F4FD1.5030308@simon.arlott.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 08:28:17PM +0100, Simon Arlott wrote:
> 
> It should be a bool that doesn't select anything, the AES and SHA modules 
> will select CRYPTO_ALGAPI. It could also depend on MVIAC3_2 || MVIA_C7 
> instead of X86_32.

Having it as a tristate means that we don't have to duplicate the
dependencies and selects that each padlock algorithm would otherwise
do.  So is there actually a problem with it being a tristate?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

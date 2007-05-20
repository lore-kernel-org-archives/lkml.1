Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXETClO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXETClO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 22:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbXETClA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 22:41:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbXETCk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 22:40:59 -0400
Date: Sat, 19 May 2007 22:40:24 -0400
From: Dave Jones <davej@redhat.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
Message-ID: <20070520024024.GB30113@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Simon Arlott <simon@fire.lp0.eu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	michal@logix.cz, ioe-lkml@rameria.de
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk> <20070518064500.GA16394@gondor.apana.org.au> <464F4FD1.5030308@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F4FD1.5030308@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 08:28:17PM +0100, Simon Arlott wrote:

 > > BTW, I noticed that this prevented CRYPTO_ALGAPI from being marked as m
 > > since it was selected by CRYPTO_DEV_PADLOCK.  So I'm turning it into a
 > > tristate again.
 > 
 > It should be a bool that doesn't select anything, the AES and SHA modules 
 > will select CRYPTO_ALGAPI. It could also depend on MVIAC3_2 || MVIA_C7 
 > instead of X86_32.

Don't forget it's possible to build 'generic' x86 kernels, which would
also want this module.

	Dave

-- 
http://www.codemonkey.org.uk

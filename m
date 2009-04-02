Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZDBDKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZDBDKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZDBDKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:10:00 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38038 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbZDBDJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:09:59 -0400
Date: Thu, 2 Apr 2009 11:09:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: andi@firstfloor.org, ghaskins@novell.com, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       rusty@rustcorp.com.au, netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402030935.GA27836@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3B64F.6070703@codemonkey.ws>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> wrote:
>
> That said, I don't think we're bound today by the fact that we're in 
> userspace.  Rather we're bound by the interfaces we have between the 
> host kernel and userspace to generate IO.  I'd rather fix those 
> interfaces than put more stuff in the kernel.

I'm sorry but I totally disagree with that.  By having our IO
infrastructure in user-space we've basically given up the main
advantage of kvm, which is that the physical drivers operate in
the same environment as the hypervisor.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

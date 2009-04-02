Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZDBDPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZDBDPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZDBDPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:15:19 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42346 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753194AbZDBDPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:15:18 -0400
Date: Thu, 2 Apr 2009 11:15:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, anthony@codemonkey.ws,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402031503.GA27930@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904011638.45135.rusty@rustcorp.com.au>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> As you point out, 350-450 is possible, which is still bad, and it's at least
> partially caused by the exit to userspace and two system calls.  If virtio_net
> had a backend in the kernel, we'd be able to compare numbers properly.

FWIW I don't really care whether we go with this or a kernel
virtio_net backend.  Either way should be good.  However the
status quo where we're stuck with a user-space backend really
sucks!

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

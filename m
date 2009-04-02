Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbZDBIx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbZDBIx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbZDBIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:53:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50665 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbZDBIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:53:12 -0400
Date: Thu, 2 Apr 2009 16:52:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402085253.GA29932@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D46089.5040204@redhat.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:
>
> virtio is already non-kvm-specific (lguest uses it) and non-pci-specific 
> (s390 uses it).

I think Greg's work shows that putting the backend in the kernel
can dramatically reduce the cost of a single guest->host transaction.
I'm sure the same thing would work for virtio too.

> If you have a good exit mitigation scheme you can cut exits by a factor 
> of 100; so the userspace exit costs are cut by the same factor.  If you 
> have good copyless networking APIs you can cut the cost of copies to 
> zero (well, to the cost of get_user_pages_fast(), but a kernel solution 
> needs that too).

Given the choice of having to mitigate or not having the problem
in the first place, guess what I would prefer :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXKOHtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXKOHtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXKOHte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:49:34 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3636 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756466AbXKOHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:49:33 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulus@samba.org (Paul Mackerras)
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Cc: davem@davemloft.net, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Organization: Core
In-Reply-To: <18235.45103.397753.321892@cargo.ozlabs.ibm.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IsZSP-0006MY-00@gondolin.me.apana.org.au>
Date: Thu, 15 Nov 2007 15:48:13 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> wrote:
>
> Well you must mean something different by "strong typing" from the
> rest of us.  Strong typing means that the compiler can check that you
> have passed in the correct types of arguments, but the compiler
> doesn't have any visibility into what structures are valid in netlink
> messages.

That's strong static typing.  Netlink is 90% strong static
typing plus 10% strong dynamic typing.  That is, it'll tell
you at run-time if you give it the wrong netlink attribute.

The types within each netlink attribute is checked at compile
time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

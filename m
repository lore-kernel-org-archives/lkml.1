Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXKOIT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXKOIT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXKOITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:19:18 -0500
Received: from mail.suse.de ([195.135.220.2]:35356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbXKOITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:19:17 -0500
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: paulus@samba.org (Paul Mackerras), davem@davemloft.net, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       eranian@hpl.hp.com, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: Andi Kleen <andi@firstfloor.org>
References: <18235.45103.397753.321892@cargo.ozlabs.ibm.com>
	<E1IsZSP-0006MY-00@gondolin.me.apana.org.au>
Date: Thu, 15 Nov 2007 09:19:11 +0100
In-Reply-To: <E1IsZSP-0006MY-00@gondolin.me.apana.org.au> (Herbert Xu's message of "Thu\, 15 Nov 2007 15\:48\:13 +0800")
Message-ID: <p73ejerdips.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> That's strong static typing.  Netlink is 90% strong static
> typing plus 10% strong dynamic typing.  That is, it'll tell
> you at run-time if you give it the wrong netlink attribute.

Well it tells you EINVAL no matter what is wrong.

That's roughly similar to a compiler whose only error message
is 'WRONG'. Or the ed school of error reporting.

That makes any checking it does barely useful.

-Andi

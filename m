Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXF3Sn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXF3Sn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXF3SnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 14:43:22 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3059 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754014AbXF3SnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 14:43:21 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: muli@il.ibm.com (Muli Ben-Yehuda)
Subject: Re: dma_mapping_ops for i386
Cc: ak@suse.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tony.luck@intel.com
Organization: Core
In-Reply-To: <20070627202839.GC4344@rhun.congress.lan>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1I4hsU-0002lx-00@gondolin.me.apana.org.au>
Date: Sun, 01 Jul 2007 02:41:02 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda <muli@il.ibm.com> wrote:
>
>> And probably some similar mechanism for network drivers that limits
>> MTUs.
> 
> Will that guarantee that block and net IOs will not straddle a page
> boundary?

Mostly.  There is the thorny case of slab debugging that breaks
these nice assumptions.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

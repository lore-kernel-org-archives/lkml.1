Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXDTBWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXDTBWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXDTBWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:22:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1847 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316AbXDTBWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:22:24 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
Cc: ak@suse.de, discuss@x86-64.org, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Organization: Core
In-Reply-To: <20070419.131014.31605466.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Hehp0-0003rL-00@gondolin.me.apana.org.au>
Date: Fri, 20 Apr 2007 11:21:58 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> 
> That file had alloc_skb_from_cache() in it, which nothing in the
> vanilla kernel ever invoked.  How did it even get there?  If it was
> put there for Xen's sake, that stinks because Xen is out of tree.

I think it was included because this is a list of all functions,
so no conspiracies to see here :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

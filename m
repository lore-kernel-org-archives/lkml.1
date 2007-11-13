Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXKNAEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXKNAEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbXKNAE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:04:28 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:30069 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754483AbXKNAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:04:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y1/0Cnt4aILTs2sWIIEb3rTjPzFV6FD+D6NIV3nFtk5rK4omBxl1YFhi5L0VclwnsLRcOYrjcvfUKHVXKiP7tNRMryiPzHBJDP7di5Am/xG7ZjmE3r6Lu/h1GdIe3kANGRcoSAK/pKK33g7rppgxLM6swbMz7260+0UvN2QmNfY=  ;
X-YMail-OSG: tOyFphYVM1lPxc_CpPxIUCx8S7PeTucL5Lt8VoRhxgE5WJM8tfwGqSPoY1y1SE6saR9VOP5jYw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Tue, 13 Nov 2007 22:41:58 +1100
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
References: <200711092336.56172.nickpiggin@yahoo.com.au> <200711101229.35822.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0711121144001.26936@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711121144001.26936@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132241.59074.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 06:44, Christoph Lameter wrote:
> On Sat, 10 Nov 2007, Nick Piggin wrote:
> > BTW. your size-2048 kmalloc cache is order-1 in the default setup,
> > wheras kmalloc(1024) or kmalloc(4096) will be order-0 allocations. And
> > SLAB also uses order-0 for size-2048. It would be nice if SLUB did the
> > same...
>
> You can try to see the effect that order 0 would have by booting with
>
> slub_max_order=0

Yeah, that didn't help much, but in general I think it would give
more consistent and reliable behaviour from slub.

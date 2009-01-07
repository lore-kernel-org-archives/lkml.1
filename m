Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZAGNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZAGNDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZAGNC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:02:56 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:48536 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZAGNCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mNWY9jJWJiEniv1+NK8Wh3p8XSc1z88YsX35/ItPK6JTGqpiIXFQ2pVzwynVYhuJr9
         eDilA0oRMGEWWshIwzYCLz91wLlWvl+5MHJaIuj1fMXeAfidJ4wKhxt+2ho57Hxb20uy
         bYRKRZ+6k0SEiH1qeBHsTZcEJQxgxosSWz6PI=
Date: Wed, 7 Jan 2009 13:02:45 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107130245.GC9677@ff.dom.local>
References: <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125217.GA26235@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:52:17PM +1100, Herbert Xu wrote:
> On Wed, Jan 07, 2009 at 12:49:46PM +0000, Jarek Poplawski wrote:
> > 
> > Hmm... in any case: take 3
> 
> Yes this should fix the corruption but it kind of defeats the
> purpose of splice by copying the data.
> 

Hmm.. Again - the main point of this patch was a proof of concept...
If the bug is really here it could be optimized (e.g. done only for
sendmesage) or fixed another way.

Jarek P.

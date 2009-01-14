Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbZANLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbZANLlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbZANLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:41:09 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53977 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZANLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nrm+vbWopdrmk6SeaF6PehvXZghJ+zkxGHajGtKxIONSSpIXc2q1U2ExaTTcE961vQ
         /PQMsiDEvxxVI0AIrhzh0mJzwkMgQoDriL9sydf+SnClp0q2HXN7roVmf1/CV4AgC7JE
         f/hFqqRYDFmd4C6CfrOs6JqkytLpLWp0yQFYs=
Date: Wed, 14 Jan 2009 11:40:59 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, dada1@cosmosbay.com,
       w@1wt.eu, ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114114059.GA5848@ff.dom.local>
References: <20090114085308.GB4234@ff.dom.local> <20090114.012919.117682429.davem@davemloft.net> <20090114094215.GC4234@ff.dom.local> <20090114.020637.181791518.davem@davemloft.net> <20090114104716.GE4234@ff.dom.local> <20090114112903.GB18662@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114112903.GB18662@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:29:03PM +1100, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 10:47:16AM +0000, Jarek Poplawski wrote:
> >
> > > > I don't think Herbert meant other ->sendpage() implementations, but I
> > > > could miss something.
> > > 
> > > I think he did :-)
> > 
> > I hope Herbert will make it clear.
> 
> Yes I did mean the other splice paths, and in particular, the path
> to disk.  I hope that's clear enough :)

So, I think I got it right: otherwise it would be enough to make this
copy to a new page only before ->sendpage() calls e.g. in
generic_splice_sendpage().

Jarek P.

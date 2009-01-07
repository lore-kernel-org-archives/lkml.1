Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZAGNLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZAGNLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZAGNLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:11:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:39228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZAGNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iaZnKz4UO76BJoJ/GrlOBWesGg9YP7xmDVMAJHF7ztK7He4dHC7tU85GoWwTOZ3dl1
         PSSv4WANWV9/TOijs/45vjUyPkyWY6VEw8ZSYHmiUDdfLk11LMXCqaEYPr/0+og/+Mq3
         t89nDGjUHz7fdfTX0mCdMtReqWRX82u81zsyg=
Date: Wed, 7 Jan 2009 13:10:57 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Willy Tarreau <w@1wt.eu>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107131057.GD9677@ff.dom.local>
References: <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net> <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net> <20090107124246.GA26034@gondor.apana.org.au> <20090107124629.GA31732@ioremap.net> <20090107125535.GC6307@1wt.eu> <20090107125734.GA26331@gondor.apana.org.au> <20090107130259.GB32336@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107130259.GB32336@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 04:02:59PM +0300, Evgeniy Polyakov wrote:
...
> If I understood correctly Jarek's patch, he wants to allocate a page and
> copy linear content of the skb there, so this will end up being the same
> case as with splicing from the file. And while generally this may be a
> good idea, but with usual 1.5k mtu this will copy every skb, which is
> rather bad idea. Will have to think :)
> 

As I mentioned earlier, I (poorly) tried to realize Changli's idea
only, and it's more to verify the reason still (after it failed with
SG method...).

Thanks,
Jarek P.

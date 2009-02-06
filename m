Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZBFJvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZBFJvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZBFJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:51:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:39906 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZBFJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eeoIiG15kzcxLXIGhWzQo5JCra3oDK6oyITSR0Af6jKXmOhOrdwwpp8Y2uszpUAX5h
         9Nddq9v4Ea3UAG+nmp0pm0kJLT0vA4FmYAS6uWlq4C6Kb2sYmgkjgvCwgyzJHzeYH1EH
         m2xKJTrX3owrfUkB5QQJDJQ5j+sYInyAoVK5g=
Date: Fri, 6 Feb 2009 09:51:20 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090206095119.GC4879@ff.dom.local>
References: <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090205.235258.257422341.davem@davemloft.net> <20090206091034.GA4879@ff.dom.local> <20090206092326.GC6645@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206092326.GC6645@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:23:26PM +1100, Herbert Xu wrote:
> On Fri, Feb 06, 2009 at 09:10:34AM +0000, Jarek Poplawski wrote:
> > 
> > Looks fine, except: you mentioned dumb NICs, which would need this
> > page space on receive, anyway. BTW, don't they need this on transmit
> > again?
> 
> A lot more NICs support SG on tx than rx.

OK, but since there is not so much difference, and we need to waste
it in some cases anyway, plus handle it later some special way, I'm
a bit in doubt.

Jarek P.

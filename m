Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXFGNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXFGNHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbXFGNHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:07:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:4524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbXFGNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ReX3VZLH1LZ2mORthwYx/xPIjC1+eLcaFvwZ91L22DtZZByo/23348gO3nkvCA7Hd1y9ksxZ6NcJw+jKovLh+cED/9lAWHUSABemoaROdevg69dsF8Rx65ZqIritAmmQUvxLIEalGokn5TbsLbvbyQ7Q8fOznA3RBxERJVHgalY=
Message-ID: <9a8748490706070607oac5b2d4j3098670a0ca6893e@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:07:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Eberhard Moenkeberg" <emoenke@gwdg.de>
Subject: Re: [PATCH]: complete cleanup of check_region
Cc: Surya <surya.prabhakar@wipro.com>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       kernel-janitors <kernel-janitors@lists.osdl.org>,
       trivial <trivial@kernel.org>, hannu@opensound.com
In-Reply-To: <Pine.LNX.4.64.0706071330500.17273@gwdu05.gwdg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181209169.2422.12.camel@bluegenie>
	 <Pine.LNX.4.64.0706071330500.17273@gwdu05.gwdg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Eberhard Moenkeberg <emoenke@gwdg.de> wrote:
> Hi,
>
> On Thu, 7 Jun 2007, Surya wrote:
>
> >
> > Hi all,
> >       This patch cleans up all the instances of check_region and
> > __check_region and replaces them with request_region and
> > __request_region. Applies and compiles clean on latest Linus tree.
> >
> > Files affected:
> >       drivers/cdrom/sbpcd.c
> >       drivers/pnp/resource.c
> >       include/linux/ioport.h
> >       kernel/resource.c
> >       sound/oss/pss.c
> >
> >
> > thanks.
> >
> >
> > Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
>
>
> in drivers/cdrom/sbpcd.c the message string should be changed too.
>
> Acked-by: Eberhard Moenkeberg <emoenke@gwdg.de>
>

Huh? I don't understand how you can ACK that patch.
Are my comments here:  http://lkml.org/lkml/2007/6/7/102  completely
out in left field?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

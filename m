Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYHJSGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYHJSGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHJSGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 14:06:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:32184 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYHJSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 14:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=TgEjaqL7m77sGkZgsbtSnSh34xN5Huyc1vWU0rFea3gsERRGN8jO05zZqMeggsN7t0
         gg30+MikZS7cfRvs8SYs10YQFVM/dIQlt/4TdzigFWgxCkrD5/+fv08RvvvWmKvFWedE
         Z8kym6keqc2Hpn6Ls8i6FUFIy8IkyOz9v0qLU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH] ide: remove unused macros from <asm-parisc/ide.h>
Date: Sun, 10 Aug 2008 20:03:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
References: <200808101747.08025.bzolnier@gmail.com> <20080810155437.GA6576@phobos.i.cabal.ca>
In-Reply-To: <20080810155437.GA6576@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808102003.27727.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 August 2008, Kyle McMartin wrote:
> On Sun, Aug 10, 2008 at 05:47:07PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Cc: Kyle McMartin <kyle@mcmartin.ca>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  include/asm-parisc/ide.h |    4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > Index: b/include/asm-parisc/ide.h
> > ===================================================================
> > --- a/include/asm-parisc/ide.h
> > +++ b/include/asm-parisc/ide.h
> > @@ -13,10 +13,6 @@
> >  
> >  #ifdef __KERNEL__
> >  
> > -#define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
> > -#define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
> > -#define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
> > -#define ide_release_region(from,extent)		release_region((from), (extent))
> >  /* Generic I/O and MEMIO string operations.  */
> >  
> 
> Thanks Bart!
> 
> Groovy... Want me to merge this, or will you shepherd it in?

In the fear of include/asm-parisc/ shuffle I would prefer that you pick it.

Thanks.

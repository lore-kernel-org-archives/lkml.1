Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbXERWQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbXERWQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXERWQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:16:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4848 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbXERWQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:16:21 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] net driver updates
Date: Sat, 19 May 2007 00:16:19 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20070508063337.GA12474@havoc.gtf.org> <200705182346.21835.m.kozlowski@tuxland.pl> <20070518145425.369cb9ff.akpm@linux-foundation.org>
In-Reply-To: <20070518145425.369cb9ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705190016.20126.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> > > index 7053026..111f23d 100644
> > > --- a/drivers/net/smc91x.h
> > > +++ b/drivers/net/smc91x.h
> > > @@ -279,6 +279,40 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
> > 
> > ...
> > 
> > > +#define SMC_outb(v, a, r) __ __ __outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) + ((r)&~1))
> > 
> > This one has unbalanced parenthesis.
> > 
> 
> I dunno how you can tell - I can't count that high.

Me neither. Simple script does that for me ;) Not sure where exactly
the parenthesis is missing so I leave it up to someone (the author?)
who knows better.

Regards,

	Mariusz

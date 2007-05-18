Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXERV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXERV5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXERV4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:56:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbXERV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:56:54 -0400
Date: Fri, 18 May 2007 14:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz =?ISO-8859-1?Q?Koz=5F=5Fowski?= <m.kozlowski@tuxland.pl>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver updates
Message-Id: <20070518145425.369cb9ff.akpm@linux-foundation.org>
In-Reply-To: <200705182346.21835.m.kozlowski@tuxland.pl>
References: <20070508063337.GA12474@havoc.gtf.org>
	<200705182346.21835.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 23:46:21 +0200
Mariusz Koz__owski <m.kozlowski@tuxland.pl> wrote:

> Hello, 
> 
> > diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> > index 7053026..111f23d 100644
> > --- a/drivers/net/smc91x.h
> > +++ b/drivers/net/smc91x.h
> > @@ -279,6 +279,40 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
> 
> ...
> 
> > +#define SMC_outb(v, a, r) __ __ __outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) + ((r)&~1))
> 
> This one has unbalanced parenthesis.
> 

I dunno how you can tell - I can't count that high.

Can this be programmed in C, rather than in cpp?

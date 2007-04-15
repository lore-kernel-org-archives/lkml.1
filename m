Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXDOM3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXDOM3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXDOM3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:29:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39729 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXDOM3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:29:33 -0400
Date: Sun, 15 Apr 2007 14:30:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: support graphics on non-zero PCI domains (take 2)
Message-ID: <20070415123020.GA19688@uranus.ravnborg.org>
References: <20070415111937.A12310@jurassic.park.msu.ru> <20070415090115.GA18103@uranus.ravnborg.org> <20070415152222.A12703@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415152222.A12703@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > +#ifndef CONFIG_ALPHA_GENERIC
> > > +EXPORT_SYMBOL(tsunami_ioportmap);
> > > +EXPORT_SYMBOL(tsunami_ioremap);
> > > +#endif
> > 
> > It looks strange that the function is always defined but conditionally exported.
> > Also usual style is to place EXPORT right after closing brace of function -
> > (with no empty lines in-between).
> 
> In a generic kernel the IO functions are never addressed directly,
> only via machine vector, so there is no point in exporting them.
> What about something like EXPORT_SYMBOL_NONGENERIC() macro?
As I wrote it looked strange. Unconditionally exporting them should not harm
and then we are one pair of ifdef/endif shorter?

Nitty gritty detail so do what you think match best.

	Sam

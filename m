Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXHTAQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXHTAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXHTAQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:16:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXHTAQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:16:48 -0400
Date: Mon, 20 Aug 2007 02:16:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [2.6 patch] update .gitignore
Message-ID: <20070820001646.GB10087@one.firstfloor.org>
References: <20070801131051.GO3972@stusta.de> <20070801190753.GB5763@martell.zuzino.mipt.ru> <20070801191037.GR3972@stusta.de> <20070819230136.GE32595@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070819230136.GE32595@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 01:01:36AM +0200, Adrian Bunk wrote:
> On Wed, Aug 01, 2007 at 09:10:37PM +0200, Adrian Bunk wrote:
> > On Wed, Aug 01, 2007 at 11:07:53PM +0400, Alexey Dobriyan wrote:
> > > On Wed, Aug 01, 2007 at 03:10:51PM +0200, Adrian Bunk wrote:
> > > > --- linux-2.6.23-rc1-mm2/.gitignore.old
> > > > +++ linux-2.6.23-rc1-mm2/.gitignore
> > > > @@ -14,18 +14,25 @@
> > > >  *.so
> > > >  *.mod.c
> > > >  *.i
> > > > +!include/asm-*/*.i
> > > 
> > > I think these should be renamed to .S and let .i alone for preprocessed
> > > stuff.
> > >...
> > 
> > Fine with me if Andi agrees.
> 
> Andi?

Hmm, perhaps rename alternative-asm.i to .h and stick a #ifdef __ASSEMBLY__
around it.

There is actually only one includer currently, but there might
be more in the future again.

-Andi


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764474AbXGQANq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764474AbXGQANq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXGQANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:13:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56574 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbXGQANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:13:34 -0400
Date: Mon, 16 Jul 2007 17:01:51 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stacked ifs (was Re: [PATCH 02/12] handle multiple
	network paths to AoE device)
Message-ID: <20070717000151.GA5982@kroah.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com> <60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com> <20070702212949.5a1a1a31.akpm@linux-foundation.org> <20070716221744.GM18477@coraid.com> <20070716153155.8a63c15d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716153155.8a63c15d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 03:31:55PM -0700, Andrew Morton wrote:
> On Mon, 16 Jul 2007 18:17:44 -0400
> "Ed L. Cashin" <ecashin@coraid.com> wrote:
> 
> > > ugh.  Do this:
> > > 
> > > 	do {
> > > 		if (t == d->htgt)
> > > 			continue;
> > > 		if (!(*t)->ifp->nd)
> > > 			continue;
> > > 		if ((*t)->nout >= (*t)->maxout)
> > > 			continue;
> > > 			
> > > 		<stuff>
> > > 	} while (++t ...)
> > 
> > Do you think the "stacked ifs" in the first version above could be
> > accepted as a convenient extension to the K&R-based conventions in
> > Documentation/CodingStyle?
> 
> Maybe.  I don't recall seeing any kernel code which uses that convention:
> everyone uses &&.  So personally I'd prefer to see kernel code stick to the
> one convention, given that there is not, afacit, any significant advantage
> to the alternative one.

I agree, let's stick with the convention we already have and use
instead.

thanks,

greg k-h

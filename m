Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXFDTUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXFDTUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbXFDTT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:19:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53638 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759753AbXFDTT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:19:59 -0400
Date: Mon, 4 Jun 2007 21:20:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] the ASYNC_* options shouldn't be user visible
Message-ID: <20070604192000.GZ5500@stusta.de>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0351F@azsmsx413.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0351F@azsmsx413.amr.corp.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:25:02AM -0700, Williams, Dan J wrote:
> > From: Williams, Dan J
> > >
> > > BTW: Please move the async_tx directory under drivers/ or lib/
> > >
> One caveat with this... md.o needs xor.o to be initialized first.
> Moving xor.o under lib/ means this assumption is broken since the
> top-level Makefile puts 'libs' after 'drivers'.
>...

What about using a different initcall level?

Depending on the link order is not such a good idea.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


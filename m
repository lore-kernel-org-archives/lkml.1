Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXJXL2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXJXL2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXJXL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:28:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46868 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbXJXL2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:28:04 -0400
Date: Wed, 24 Oct 2007 13:29:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
Message-ID: <20071024112938.GA1770@uranus.ravnborg.org>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com> <20071024112453.GP14671@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024112453.GP14671@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 01:24:53PM +0200, Jens Axboe wrote:
> On Wed, Oct 24 2007, Haavard Skinnemoen wrote:
> > Hi Linus,
> > 
> > Sorry about sending you pull requests so rapidly, but Jens broke my
> > dma-mapping.h yesterday. Or you may say the bug was there to begin with
> > and Jens merely exposed it, but that makes it sound like my fault ;-)
> > 
> > Anyway, please pull from
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus
> > 
> > to receive the following update.
> 
> You should not take the blame :-)
> 
> I'm collecting these patches, so I'll pull your fix and make sure it
> gets to Linus today along with the other fixes.

How about doing a "git grep asm/scatterlist"
and fix all victims to use linux/scatterlist?
Or you maybe did this already.

	Sam

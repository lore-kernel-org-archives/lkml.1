Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYJTRdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYJTRdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYJTRct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:32:49 -0400
Received: from kroah.org ([198.145.64.141]:45254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbYJTRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:32:48 -0400
Date: Mon, 20 Oct 2008 09:51:42 -0700
From: Greg KH <greg@kroah.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Christopher Harrer <charrer@alacritech.com>,
       Michael Miles <mmiles@alacritech.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linus@kroah.com
Subject: Re: linux-next: build failure
Message-ID: <20081020165142.GA7166@kroah.com>
References: <20081020230420.aa85f83b.sfr@canb.auug.org.au> <20081020154857.GC24666@kroah.com> <3aaafc130810200933s7299378eg6924089a58b9778a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130810200933s7299378eg6924089a58b9778a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 12:33:29PM -0400, J.R. Mauro wrote:
> On Mon, Oct 20, 2008 at 11:48 AM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Oct 20, 2008 at 11:04:20PM +1100, Stephen Rothwell wrote:
> >> Hi Greg,
> >>
> >> Today's linux-next build (powerpc allyesconfig) failed like this:
> >>
> >> In file included from drivers/staging/sxg/sxg.c:77:
> >> drivers/staging/sxg/sxghif.h:859: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'Compilation'
> >> drivers/staging/sxg/sxg.c: In function 'sxg_transmit_packet':
> >> drivers/staging/sxg/sxg.c:1949: error: 'SXG_SGL_BUF_SIZE' undeclared (first use in this function)
> >> drivers/staging/sxg/sxg.c:1958: error: implicit declaration of function 'SXG_SGL_BUFFER'
> >> drivers/staging/sxg/sxg.c:1958: warning: assignment makes pointer from integer without a cast
> >> drivers/staging/sxg/sxg.c: In function 'sxg_mcast_set_mask':
> >> drivers/staging/sxg/sxg.c:2846: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
> >>
> >> I applied the following patch.
> >
> > Ah, doh, sorry, I should have caught that.  I'll go apply this to the
> > tree, thanks.
> 
> Greg,
> 
> The slicoss driver also from Alacritech looks like it needs a depends
> on X86 as well. Should the sxg and slicoss drivers from Alacritech be
> doing things like this (sxg/sxghif.h:851, slicoss/slicoss.c:960):

Yes, it needs it too.

thanks,

greg k-h

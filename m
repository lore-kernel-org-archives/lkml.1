Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZALK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZALK6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZALK6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:58:06 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:54129 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZALK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:58:05 -0500
Date: Mon, 12 Jan 2009 11:59:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@snapgear.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-m68k@vger.kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig can't build
Message-ID: <20090112105942.GA10936@uranus.ravnborg.org>
References: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48E9AE16.2000002@snapgear.com> <20090112104447.GG28564@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112104447.GG28564@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 07:44:47PM +0900, Paul Mundt wrote:
> On Mon, Oct 06, 2008 at 04:20:06PM +1000, Greg Ungerer wrote:
> > Hi Kosako,
> > 
> > KOSAKI Motohiro wrote:
> > >I guess nobody don't test m68knommu at all last three month.
> > >Do we still need to maintain this architecture?
> > 
> > Yes, we do.
> > 
> Any effort to get m68knommu folded in to m68k proper? This might help
> with some of your bitrot issues.. And likely less work to do in
> supporting those m68knommu parts that ship with MMUs ;-)
> 
> m68knommu is the only one of the mmu/nommu variants left that ships in
> its own architecture directory rather than being folded in to its parent.
> It would be good to get rid of it one of these days.

>From the outside it looks like there are indeed a whish to do so
but both m68k and m68knommu maintainers seems to be busy with other stuff.

Not that I can think of what is more important than to merge the two
architectures ;-)

If I get some spare time one day I have actually planned to try to
help a little - but that would require an active maintainer..

We just did the exercise with sparc/sparc64 unification and
if you forget the few times I broke sparc32 then it went well
with only limited problems.

One key factor why it went well was that patches were reviewed
and applied within a few days whch is why I stresses that the
maintainer needs spare time to support the effort.

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYBLEcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYBLEcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbYBLEb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:31:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbYBLEbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:31:55 -0500
Date: Mon, 11 Feb 2008 20:31:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
In-Reply-To: <20080212042133.GA4625@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 20:21:33 -0800
Greg KH <greg@kroah.com> wrote:


> > The maintainer will be notified.  I hope to provide some clue as to
> > what the conflict is with, but probably not initially.
> > 
> > I will attempt to build the tree between each merge (and a failed
> > build will again cause the offending tree to be dropped).
> 
> This is going to get really interesting, especially when (not if) we
> do more global api changes.  Look at the last round of kobject
> changes. That touched a lot of different places, and other trees
> ended up not building because of it, because I changed apis and they
> had added new code based on the old apis.
> 
> I think the only way to fix this is not going to just "drop the tree"
> like you are suggesting, but to let both people know (the person who
> caused the change, and the person who's tree broke after the merge),
> and then either add a "fixup patch" for the build like Andrew has been
> doing, or disabling something from the build section.
> 

in my experience, the only chance you have is doing API changes as first in the set of changes,
and then hoping (making) all other trees use the new APIs. Any other order just turns into
an impossible mismash.

I can see the point of doing an LKML annouce of the new API after the series is done, so that 
all other maintainers have a chance to fix their trees (this of course is only for new occurances
of the old api showing up; the api change series should convert all existing users)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

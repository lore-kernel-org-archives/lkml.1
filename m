Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXEJRvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXEJRvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbXEJRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:51:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44234 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753640AbXEJRv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:51:29 -0400
Date: Thu, 10 May 2007 19:51:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Olaf Hering <olh@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Bill Fink <billfink@mindspring.com>
Subject: Re: [git pull] New firewire stack (updated)
Message-ID: <20070510175129.GN23574@stusta.de>
References: <4637A29F.6070302@redhat.com> <tkrat.b635518ff171071d@s5r6.in-berlin.de> <20070510173850.GA31826@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070510173850.GA31826@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 06:38:50PM +0100, Christoph Hellwig wrote:
> On Thu, May 10, 2007 at 07:26:56PM +0200, Stefan Richter wrote:
> > Linus, please pull from the juju branch at
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git juju
> > 
> 
> ACK from me.  I still have some comments but none of them is a merge
> blocker.
> 
> > What did _not_ change:
> > 
> >   - The drivers are still named fw-core, fw-ohci, fw-sbp2 (but they
> >     feature conditional aliases sbp2 and ohci1394 now).  Adrian
> >     suggested the prefix firewire- instead of fw-.
> > 
> >   - The drivers still live in drivers/firewire/, i.e. have not been put
> >     into mainline's drivers/ieee1394/.
> 
> I don't quite like that.  Then again git handles renames pretty nicely
> and I hope we'll just shift the new drivers in place when the old code
> goes away completely to give people a seamless migration.

For users it shouldn't matter where the code is located in the kernel 
sources (and "firewire" is IMHO for many people more meaningful than 
"ieee1394").

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


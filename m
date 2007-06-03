Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXFCVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXFCVRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXFCVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:17:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59188 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXFCVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:17:23 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 17:15:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Tim Hockin <thockin@google.com>
cc: Roland Dreier <rdreier@cisco.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
In-Reply-To: <cc96a5040706031408i54116922m7a83c7e0b07181e6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706031714070.19004@localhost.localdomain>
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain> 
 <20070603132309.508738b7.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>  <adazm3glqcr.fsf@cisco.com>
 <cc96a5040706031408i54116922m7a83c7e0b07181e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Tim Hockin wrote:

> There were other patches which added more COBALT support, but they
> were dropped or lost or whatever.
>
> I would not balk at having that code yanked.  I never got around to
> doing proper Cobalt support for modern kernels. :(
>
> On 6/3/07, Roland Dreier <rdreier@cisco.com> wrote:
> >  > > >   there is no Kconfig file which defines the selectable option
> >  > > > "COBALT", which means that this snippet from drivers/char/nvram.c:
> >  > > >
> >  > > > #  if defined(CONFIG_COBALT)
> >  > > > #    include <linux/cobalt-nvram.h>
> >  > > > #    define MACH COBALT
> >  > > > #  else
> >  > > > #    define MACH PC
> >  > > > #  endif
> >  > > > never evaluates to true, therefore making <linux/cobalt-nvram.h>
> >  > > > fairly useless, at least under the circumstances.
> >
> >  > > Maybe it should be MIPS_COBALT ?
> >
> >  > that's the first thing that occurred to me, but that header file is
> >  > copyright sun microsystems and says nothing about MIPS, so that didn't
> >  > really settle the issue.  that's why i'd rather someone else resolve
> >  > this one way or the other.
> >
> > Actually, looking through the old kernel history, it looks like this
> > was added by Tim Hockin's (CCed) patch "Add Cobalt Networks support to
> > nvram driver".  Which added this to drivers/cobalt:
> >
> > +bool 'Support for Cobalt Networks x86 servers' CONFIG_COBALT
> >
> > I guess Tim can clear up what's intended...

ok, that sounds like it might be a bigger issue than just a dead
CONFIG variable.  if that's all it is, i can submit a patch.  if it's
more than that, i'll leave it to someone higher up the food chain to
figure out what cobalt-related stuff should be yanked.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

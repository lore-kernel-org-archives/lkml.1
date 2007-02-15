Return-Path: <linux-kernel-owner+w=401wt.eu-S1161687AbXBOXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161687AbXBOXKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161686AbXBOXKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:10:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:25977 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161680AbXBOXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:10:21 -0500
Date: Thu, 15 Feb 2007 15:05:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Simmons <jsimmons@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] MAINTAINERS: mark framebuffer as Orphan
Message-Id: <20070215150526.1fd63b3e.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702152224570.6415@pentafluge.infradead.org>
References: <20070215132549.c182f7bf.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0702152224570.6415@pentafluge.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 22:26:10 +0000 (GMT) James Simmons wrote:

> 
> I wouldn't say it orphan. I just can't spend 8 hours a day on it. 
> Alot of patches have been flowing into the layer.

So would you like to leave it as Maintained or change it to
"Odd Fixes"?  (Maintained => a maintainer)  From the MAINTAINTERS file:

	Supported:	Someone is actually paid to look after this.
	Maintained:	Someone actually looks after it.
	Odd Fixes:	It has a maintainer but they don't have time to do
			much other than throw the odd patch in. See below..
	Orphan:		No current maintainer [but maybe you could take the
			role as you write your new code].
	Obsolete:	Old code. Something tagged obsolete generally means
			it has been replaced by a better system and you
			should be using that.


> On Thu, 15 Feb 2007, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Are we ready to do this?
> > I'd love for Tony to return, but he's been missing for awhile now.
> > 
> > So this give us the following major areas that are marked as Orphan:
> > 
> > Firmware loader
> > Framebuffer
> > Serial (8250/16x50)
> > 
> > and PCMCIA has a Team.  It doesn't seem to be hurting.  :)
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  MAINTAINERS |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > --- linux-2.6.20-git9.orig/MAINTAINERS
> > +++ linux-2.6.20-git9/MAINTAINERS
> > @@ -1321,11 +1321,9 @@ W:	http://www.farsite.co.uk/
> >  S:	Supported
> >  
> >  FRAMEBUFFER LAYER
> > -P:	Antonino Daplas
> > -M:	adaplas@pol.net
> >  L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
> >  W:	http://linux-fbdev.sourceforge.net/
> > -S:	Maintained
> > +S:	Orphan
> >  
> >  FREESCALE SOC FS_ENET DRIVER
> >  P:	Pantelis Antoniou

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

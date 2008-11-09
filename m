Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYKINNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYKINNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYKINNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:13:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbYKINNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:13:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Date: Sun, 9 Nov 2008 14:17:53 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200811081353.34442.rjw@sisk.pl> <20081108215458.1799896b.akpm@linux-foundation.org> <20081109113736.GE6094@elf.ucw.cz>
In-Reply-To: <20081109113736.GE6094@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091417.53663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Pavel Machek wrote:
> On Sat 2008-11-08 21:54:58, Andrew Morton wrote:
> > On Sat, 8 Nov 2008 14:12:21 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Saturday, 8 of November 2008, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > This would be good to have in .28 IMO.
> > > > 
> > > > Actually, this makes sense even for .27-stable, AFAICT.
> > > 
> > > Yes, it does, but it has to be merged first. :-)
> > 
> > It applies to 2.6.26 (at least).  Is there no need for it in kernels
> > earlier than 2.6.27.x?
> 
> It would be nice to fix it there, too. (OTOH that config never worked
> and we did not see huge pile of complains, so I guess the world would
> not fall down if it was not in 2.6.26...)

Yes, it's a bug, so it would be nice to fix it.  Still, the practical meaning
of the fix would be minimal in 2.6.26 and earlier kernels IMO.

Thanks,
Rafael

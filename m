Return-Path: <linux-kernel-owner+w=401wt.eu-S1030487AbXBTWRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487AbXBTWRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030496AbXBTWRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:17:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34377 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030487AbXBTWRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:17:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Tue, 20 Feb 2007 23:12:29 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702200220.22721.rjw@sisk.pl> <20070219223151.b3fbe18e.akpm@linux-foundation.org>
In-Reply-To: <20070219223151.b3fbe18e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702202312.30067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 February 2007 07:31, Andrew Morton wrote:
> On Tue, 20 Feb 2007 02:20:21 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 18 February 2007 20:43, Andrew Morton wrote:
> > > On Sun, 18 Feb 2007 13:44:54 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > > > > 
> > > > > Temporarily at
> > > > > 
> > > > >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > > > > 
> > > > > Will appear later at
> > > > > 
> > > > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > > > 
> > > > Two problems:
> > > > 
> > > > 1) A showstopper with the root partition on RAID1:
> > > > 
> > > > md: raid1 personality registered for level 1
> > > > [--snip--]
> > > > md: multipath personality registered for level -4
> > > > register_blkdev: failed to get major for mdp
> > > > [--snip--]
> > > > VFS: Cannot open root device "md1" or unknown-block(0,0)
> > > 
> > > Someone else reported that against mainline.  Can you please debug it a bit?
> > 
> > For now I can only say 2.6.20 + origin.patch breaks.
> > 
> > However, it's a SUSE 10.1 system with gcc 4.1.0 and this may be the reason.
> > I'll check that tomorrow.
> 
> Yes, Rolf says this goes away when you stop using gcc-4.1.0.
> 
> I'm hoping that churning the code around like below makes things work
> right.

Yes, that helps.

Thanks,
Rafael

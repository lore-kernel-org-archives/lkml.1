Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXFTPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXFTPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXFTPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:39:17 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:62574 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbXFTPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:39:16 -0400
Date: Thu, 21 Jun 2007 00:38:13 +0900
From: Mattia Dongili <malattia@linux.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Message-ID: <20070620153813.GA3569@inferi.kami.home>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070620052222.GA4452@inferi.kami.home> <200706201340.19404.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706201340.19404.rjw@sisk.pl>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc5-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:40:18PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 20 June 2007 07:22, Mattia Dongili wrote:
> > On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > 
> > Hello,
> > on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> > is becoming troublesome as different sets have slightly different
> > problems.
> > At one point (with the GREGKH usb stuff built) I had the kernel
> > reporting it cannot stop the usb-storage thread so I guess that
> > something later in the series made things worse (freezable workqueues?).
> > 
> > Clues?
> 
> Can you please try 2.6.22-rc5 with the patches from
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/
> 
> applied.  That should allow us to eliminate some suspects. ;-)

you're safe then! .22-rc5 + your suspend patch-set can suspend and
resume happily.

-- 
mattia
:wq!

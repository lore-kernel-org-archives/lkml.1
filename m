Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbZG3UE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbZG3UE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZG3UE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZG3UE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:04:58 -0400
Date: Thu, 30 Jul 2009 12:51:54 -0700
From: Greg KH <gregkh@suse.de>
To: Jakob Gruber <jakob.gruber@kabelnet.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing device IDs in rt2870
Message-ID: <20090730195154.GA27953@suse.de>
References: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
 <20090728211216.GA12363@suse.de>
 <20090729171107.155719b5.jakob.gruber@kabelnet.at>
 <20090729161643.GA6313@suse.de>
 <20090730203736.f1efbbfe.jakob.gruber@kabelnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730203736.f1efbbfe.jakob.gruber@kabelnet.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 08:37:36PM +0200, Jakob Gruber wrote:
> On Wed, 29 Jul 2009 09:16:43 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> <snip>
> > > 
> > > I haven't tested rt2870 in 2.6.30 thoroughly because of this bug
> > > (http://bugzilla.kernel.org/show_bug.cgi?id=13638), which forces me to
> > > use the driver from the Ralink website instead of the kernel module.
> > > However, I can confirm that - until running into the bug - the Belkin
> > > card also works in 2.6.30. 
> > 
> > Ah, that sucks.  I should revert that patch, if you do that, does the
> > device work properly for you?
> 
> 'git revert' didn't work out of the box, and I don't think I'm skilled
> enough to revert it manually :) However, I posted some more
> information at http://bugzilla.kernel.org/show_bug.cgi?id=13638#c9 ,
> including everything.log during the crash.

I just got confirmation from someone else on lkml that reverting this on
2.6.30.1 worked for them, so I'll port it to mainline and apply it there
as well as get it into the .30-stable tree.

> 
> > 
> > > A patch for adding the Belkin device ID is attached. I removed the
> > > other 2 IDs from http://bugzilla.kernel.org/show_bug.cgi?id=13459
> > > since I do not own these devices and cannot verify them. The ID is
> > > only added to the "#ifndef RT30xx" block, same as the patch applied to
> > > the Archlinux kernel.
> > 
> > I'll take the other two ids, now that it makes more sense.
> > 
> > Care to respin with the 2 new ids, and add a "Signed-off-by:" to the
> > patch so I can properly apply it?
> 
> Done, patch is attached. 

Looks good, I'll queue it up.

thanks,

greg k-h

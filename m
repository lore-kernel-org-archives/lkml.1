Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZFUWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZFUWlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFUWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:41:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40611 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZFUWlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:41:46 -0400
Date: Sun, 21 Jun 2009 23:41:47 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andy Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906212340440.20307@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> On Sun, 21 Jun 2009, Dave Airlie wrote:
> > > 
> > > I tried this tree (specifically, a merge of Linus' fb20871 this tree) on
> > > Fedora 11 with modesetting enabled on an integrated Radeon 2100, and plymouthd
> > > crashes immediately with a corrupt page table.  Photo attached.  After the
> > > crash, bootup stops, although ctrl-alt-del works.
> > 
> > You need a different userspace, -ati from koji in F11 should do it.
> 
> Dave - no amount of userspace differences make a corrupted page table 
> acceptable. 

I was original responding to a line I saw in his dmesg (which was about an 
ioctl not being available, I only got to parsing the crash later.

 
> This needs to be fixed. No excuses. Kernel crashes are never an issue of 
> "you used the wrong user space".

Agreed, and we block old userspaces running on KMS kernels (at least 
trying to use DRI) and I thought that was what he was seeing.

Dave.

> 
> 		Linus
> 
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 

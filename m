Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0CEBQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:16:38 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:37908 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0CEBQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:16:30 -0500
Date: Fri, 5 Mar 2010 02:16:27 +0100
From: Luc Verhaegen <libv@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305011627.GA524@skynet.be>
References: <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain> <20100305005617.GA31883@skynet.be> <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:08:00PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Mar 2010, Luc Verhaegen wrote:
> > 
> > libdrm is composed of the main libdrm, and several driver specific 
> > libdrms today (... and libkms, yes).
> 
> It's actually not libdrm that is the primary issue, I'm sorry for saying 
> that.
> 
> It's the nouveau_drv.so thing - the actual X driver. 
> 
> Anyway, since I had looked at the libdrm sources, I had most of this on my 
> machine anyway, so I've compiled it all, and am going to reboot and see if 
> I can make a few symlinks work.
> 
> IOW, right now I have this:
> 
>    [root@nehalem ~]# cd /usr/lib64/xorg/modules/drivers/
>    [root@nehalem drivers]# ll nouveau_drv.so*
>    lrwxrwxrwx 1 root root      21 2010-03-04 17:00 nouveau_drv.so -> nouveau_drv.so-0.0.16
>    -rwxr-xr-x 1 root root  343784 2010-03-04 16:59 nouveau_drv.so-0.0.15
>    -rwxr-xr-x 1 root root 1698805 2010-03-04 16:59 nouveau_drv.so-0.0.16
> 
> and I'll see if that works (yeah, yeah, I didn't strip the thing, and 
> it's compiled with whatever defaults that probably include debugging too, 
> so it's huge).
> 
> Quite frankly, I still think that I shouldn't have to play these kinds of 
> games. I think the versioning should be built in. And I still think that 
> "staging" is not an excuse for "it's bad crap, and we don't care"
> 
> 			Linus

In an ideal world, you shouldn't be forced to update anything except 
some/all of the driver bits.

But the fact that libdrm is lumped together as it is, and that mesa is a 
monolith, forces you to update a more significant portion of your 
system. You have to resort to some serious manual labour to get around 
that atm.

Luc Verhaegen.

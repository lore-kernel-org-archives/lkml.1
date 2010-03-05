Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0CEBI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab0CEBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:08:14 -0500
Date: Thu, 4 Mar 2010 17:08:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Luc Verhaegen <libv@skynet.be>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305005617.GA31883@skynet.be>
Message-ID: <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
 <20100305005617.GA31883@skynet.be>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Luc Verhaegen wrote:
> 
> libdrm is composed of the main libdrm, and several driver specific 
> libdrms today (... and libkms, yes).

It's actually not libdrm that is the primary issue, I'm sorry for saying 
that.

It's the nouveau_drv.so thing - the actual X driver. 

Anyway, since I had looked at the libdrm sources, I had most of this on my 
machine anyway, so I've compiled it all, and am going to reboot and see if 
I can make a few symlinks work.

IOW, right now I have this:

   [root@nehalem ~]# cd /usr/lib64/xorg/modules/drivers/
   [root@nehalem drivers]# ll nouveau_drv.so*
   lrwxrwxrwx 1 root root      21 2010-03-04 17:00 nouveau_drv.so -> nouveau_drv.so-0.0.16
   -rwxr-xr-x 1 root root  343784 2010-03-04 16:59 nouveau_drv.so-0.0.15
   -rwxr-xr-x 1 root root 1698805 2010-03-04 16:59 nouveau_drv.so-0.0.16

and I'll see if that works (yeah, yeah, I didn't strip the thing, and 
it's compiled with whatever defaults that probably include debugging too, 
so it's huge).

Quite frankly, I still think that I shouldn't have to play these kinds of 
games. I think the versioning should be built in. And I still think that 
"staging" is not an excuse for "it's bad crap, and we don't care"

			Linus

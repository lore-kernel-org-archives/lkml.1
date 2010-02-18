Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0BRJq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:46:26 -0500
Received: from 60-242-66-41.static.tpgi.com.au ([60.242.66.41]:45664 "EHLO
	fs.beware.dropbear.id.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754880Ab0BRJqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:46:23 -0500
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 04:46:22 EST
Subject: Re: Linux mdadm superblock question.
From: Ian Dall <ian@beware.dropbear.id.au>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Nick Bowler <nbowler@elliptictech.com>
In-Reply-To: <201002162318.33950.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <201002162206.32797.volkerarmin@googlemail.com>
	 <20100216220020.GA1036@emergent.ellipticsemi.com>
	 <201002162318.33950.volkerarmin@googlemail.com>
Content-Type: text/plain
Date: Thu, 18 Feb 2010 19:57:03 +1030
Message-Id: <1266485223.25367.29.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (fs.beware.dropbear.id.au [10.0.0.1]); Thu, 18 Feb 2010 19:57:18 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 23:18 +0100, Volker Armin Hemmann wrote:
> On Dienstag 16 Februar 2010, Nick Bowler wrote:
> > On 22:06 Tue 16 Feb     , Volker Armin Hemmann wrote:
> > > On Dienstag 16 Februar 2010, Bill Davidsen wrote:
> > > > Volker Armin Hemmann wrote:
> > > > > On Sonntag 14 Februar 2010, you wrote:
> > > > >> In other words, 'auto-detection' for 1.x format devices is using an
> > > > >> initrd/initramfs.
> > > > > 
> > > > > which makes 1.x format useless for everybody who does not want to
> > > > > deal with initrd/initramfs.
> > > > 
> > > > You make this sound like some major big deal. are you running your own
> > > > distribution? In most cases mkinitrd does the right thing when you
> > > > "make install" the kernel, and if you are doing something in the build
> > > > so complex that it needs options, you really should understand the
> > > > options and be sure you're doing what you want.
> > > > 
> > > > Generally this involves preloading a module or two, and if you need it
> > > > every time you probably should have built it in, anyway.
> > > > 
> > > > My opinion...
> > > 
> > > I am running my own kernels - and of course everything that is needed to
> > > boot and get the basic system up is built in. Why should I make the disk
> > > drivers modules?
> > > That does not make sense.
> > 
> > I agree that it makes little sense to make something a module when you
> > can't unload it anyway, but...
> > 
> > > And the reason is simple: even when the system is completely fucked up, I
> > > want a kernel that is able to boot until init=/bin/bb takes over.
> > 
> > I put a complete set of recovery tools into my initramfses so that when
> > the system is completely fucked up, I have a kernel that is able to boot
> > until rdinit=/bin/zsh (or /bin/bb, if you prefer) takes over.
> > 
> > This has the added advantage of working when the root filesystem cannot
> > be mounted at all: a scenario which does not seem too far-fetched when
> > the filesystem is located on a raid array.
> 
> and what do you do if you have to boot from a cd/usb stick and need to access 
> the raid?
> 
> Simple with auto assembling. Not so much without.

I'm not sure what the problem is. I've had to do this (because the disk
with grub on the MBR was the one that failed - now I put grub on them
all).

I booted of the fedora install disk in rescue mode. Told it not to try
and mount any system disks, got into a shell and ran mdadm -As 

I'm not sure what else a kernel auto-assemble would be expected to do
that mdadm -As wouldn't...


-- 
Ian Dall <ian@beware.dropbear.id.au>


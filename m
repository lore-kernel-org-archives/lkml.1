Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbXJYW6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbXJYW6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXJYW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:58:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40524 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752980AbXJYW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:58:06 -0400
Date: Fri, 26 Oct 2007 00:58:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Lothian <mike@fireburn.co.uk>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
Message-ID: <20071025225832.GZ30533@stusta.de>
References: <20071025185022.GP30533@stusta.de> <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com> <20071025191723.GQ30533@stusta.de> <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com> <20071025195020.GS30533@stusta.de> <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com> <4720FF2B.9020802@googlemail.com> <fc94aae90710251430s669418e5v72282ff5f8a5691e@mail.gmail.com> <20071025214647.GX30533@stusta.de> <fc94aae90710251542j54e0dfbfh90ef049ed6aad33c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc94aae90710251542j54e0dfbfh90ef049ed6aad33c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 11:42:47PM +0100, Michael Lothian wrote:
> > What exactly is irritating?
> > Please name the problems so that they can be fixed.
> >
> > > Detecting the cpu and using march=native could be all part of that
> >
> > You don't need march=native for this.
> >
> > You have to set the right config option for your CPU and you
> > automatically get the right compiler options.
> 
> Well when doing a lspci here are some specific examples:
> 
> 
> 
> 03:02.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 
> What modules would you think you'd need to compile to get this to work?
> 
> No it's not budget card os buget card ci even though the card its self
> has no cam interface
> 
> 
> 
> 00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
> 
> Is there any indication from this piece of info that the intel hda
> driver is required?
> 
> 
> 
> 00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
> 
> This uses AHCI
> 
> 
> 
> As for the i2c and the hardware monitoring support well that's mostly guess work
> 
> 
> Half the time it's easier doing a lsmod when booted on a livecd and
> trying to figure out what options are required from the module names
> which sometime can be just as tricky.

Sure, distributions already have solved this and you can use their 
work.

> Why not auto detect the CPU the same way GCC does and automatically
> set the correct CPU and then go the whole hog and let GCC use the
> correct flags if it's new enough using native
> 
> I can't understand why you wouldn't find this useful when setting up a
> customised kernel.
> 
> Maybe even having a make addnewhardware option to quickly add extra
> devices to your config file.

Knowing your CPU is much easier to figure out than to figure out the 
BIOS settings of your SATA controller that determine how to access it.

If you do not even know what CPU you have you should really not compile 
your own kernel.

> Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


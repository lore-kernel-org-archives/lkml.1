Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZFKO5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZFKO5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZFKO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:57:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43331 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZFKO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:57:27 -0400
Date: Thu, 11 Jun 2009 16:57:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611145721.GB2982@ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com> <20090611081012.GD8592@elf.ucw.cz> <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com> <20090611110946.GA7523@elf.ucw.cz> <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com> <20090611114825.GD7523@elf.ucw.cz> <a55d774e0906110453g517d11of810e951a4a894f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906110453g517d11of810e951a4a894f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 04:53:10, Brian Swetland wrote:
> On Thu, Jun 11, 2009 at 4:48 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >>
> >> You'll need to fastboot boot arch/arm/boot/zImage ramdisk.img
> >
> > Aha, fastboot implies that ramdisk is optional.. apparently it is not.
> 
> Well, it *is* optional -- but the kernel as we build it needs an
> initrd to do much that's visible.  Could probably enable fb console
> and provide a commandline that points console there (-c "kernel
> commandline"  argument to fastboot).

Ok... but still no success. For some reason it seems to work better if
I use uImage (at least I get blank screen) than zImage (fastboot just
hangs).

> >> Extracting the ramdisk.img from the boot.img in the boot partition on
> >> an existing device is a pain.  If you happen to have a cupcake
> >> userspace built from source that ramdisk.img should be suitable.  If
> >> not, I'll try to dig up a suitable ramdisk image tomorrow -- it's just
> >> init, init.rc, and adb, but it is necessary to boot.
> >
> > I tried using ramdisk.img from sdk:
> >
> > root@amd:/data/l/android# ./fastboot boot
> > /data/l/linux-msm/arch/arm/boot/uImage
> > /data/l/android/sdk/platforms/android-1.5/images/ramdisk.img
> >
> > ...no luck :-(.
> 
> Is a uImage compatible with zImage (if the bootloader copies it to
> 0x10008000 and jumps there will it start?)

No idea :-(. (And thanks for ramdisk.img; it is different from what I
have, but results seem same).

> > Better Kconfig description would certainly be nice. Renaming
> > board-trout* to board-dream* would be also nice (and should be doable
> > without any intrusive changes...?)
> 
> Ah, I see.  Yes, renaming the files would be easy to do and that's
> totally reasonable.  I thought you wanted the machine type name
> changed.

Good.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

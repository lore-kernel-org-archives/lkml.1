Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZFMAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZFMAmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFMAmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:42:09 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:37984
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbZFMAmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:42:08 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zz146fK1432R98dR1805M9371Pzz1202hzzz2fh6bh17ch63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
Message-ID: <4A32F5C9.2040206@am.sony.com>
Date: Fri, 12 Jun 2009 17:41:45 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       <ibm@android.com>, <san@android.com>, <rlove@google.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090610103131.GB13885@elf.ucw.cz>	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>	 <20090611081012.GD8592@elf.ucw.cz>	 <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>	 <20090611110946.GA7523@elf.ucw.cz> <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
In-Reply-To: <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2009 00:41:46.0068 (UTC) FILETIME=[BAB82140:01C9EBBF]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Swetland wrote:
> On Thu, Jun 11, 2009 at 4:09 AM, Pavel Machek<pavel@ucw.cz> wrote:
>> Anyway, now I have a tree, and yes it compiles. (After some
>> "interesting" questions; perhaps defconfig should be updated?)
>>
>> Unfortunately, upon fastboot boot uImage, it hangs with black screen
>> and backlight on.
> 
> You'll need to fastboot boot arch/arm/boot/zImage ramdisk.img
> 
> Extracting the ramdisk.img from the boot.img in the boot partition on
> an existing device is a pain.  If you happen to have a cupcake
> userspace built from source that ramdisk.img should be suitable.  If
> not, I'll try to dig up a suitable ramdisk image tomorrow -- it's just
> init, init.rc, and adb, but it is necessary to boot.

I found the tools located here:
"HOWTO: Unpack, Edit, and Repack Boot Images"
http://forum.xda-developers.com/showthread.php?t=443994

to be very helpful.

I wrote a small wrapper script to extract
the recovery image, substitute a new kernel, and re-install it
on the ADP1, which I use for my own kernel testing. I can post
it somewhere if people are interested.

I use the recovery partition instead of the boot partition.
I leave the boot partition alone since this thing is also my
phone and when I'm done debugging I want to get back to
the original code and config easily.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================


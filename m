Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZFLQD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZFLQD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZFLQDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:03:18 -0400
Received: from linode.davidb.org ([72.14.176.16]:56015 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZFLQDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:03:17 -0400
X-Greylist: delayed 712 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 12:03:17 EDT
Date: Fri, 12 Jun 2009 09:00:16 -0700
From: David Brown <davidb@quicinc.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612160015.GA8942@linode.davidb.org>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20090612150504.GA15084@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:05:04PM +0200, Pavel Machek wrote:

>+Board code names
>+----------------
>+
>+board-halibut is a qualcomm reference design.  board-sapphire is HTC
>+Magic.  board-trout is HTC Dream/G1/ADP1.

Specifically, 'board-halibut' is one particular Qualcomm reference
design, currently one of seven.

Support for these devices is in our reference kernel at:

    https://www.codeaurora.org/gitweb/quic/le/?p=kernel/msm.git;a=summary

in the android-msm-2.6.29 branch, which is about 213 commits divergent
from Google's tree, posted earlier.  We've been trying to work to get
our commits to be closer to being appropriate for inclusion in the
mainstream kernel.  Sadly, most of out work so far ended up being
squashed into a single "Initial contribution" commit.

It's also a bit unfortunate that our primary development happens on
development boards that aren't available to the general public.  From
what I read here, it seems that mainline change to support the HTC
7201A-based devices is probably the most useful starting point.

I'm hoping soon to be able to be involved more directly with ARM
kernel development rather than just in an after-the-fact manner.

>+Booting your kernel
>+-------------------
>+
>+hold down camera and red button to boot into rainbow screen. Then
>+
>+./fastboot boot linux-msm/arch/arm/boot/zImage ramdisk.img

You should also be able to do:

    ./fastboot boot boot.img

but this is probably only useful if you use the rest of the Android
build system, since it will assemble boot.img from the kernel image
and the ramdisk.

David Brown
davidb@quicinc.com

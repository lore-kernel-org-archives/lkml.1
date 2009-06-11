Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbZFKO6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbZFKO6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZFKO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:58:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZFKO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:58:16 -0400
Date: Thu, 11 Jun 2009 16:58:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611145811.GC2982@ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com> <20090611081012.GD8592@elf.ucw.cz> <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com> <20090611110946.GA7523@elf.ucw.cz> <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com> <20090611114825.GD7523@elf.ucw.cz> <a55d774e0906110453g517d11of810e951a4a894f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

I tried that without much luck. Also... defconfig has mem=64M. Is
that correct?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

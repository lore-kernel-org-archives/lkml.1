Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbYGORgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbYGORgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYGORgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:36:31 -0400
Received: from 1wt.eu ([62.212.114.60]:4002 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYGORga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:36:30 -0400
Date: Tue, 15 Jul 2008 19:35:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715173520.GA30521@1wt.eu>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org> <20080715045848.GG1369@1wt.eu> <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:55:37AM -0700, Linus Torvalds wrote:
> Willy, stop this blathering.
> 
> I suspect I will have to just delete this thread unread because it's so 
> full of total crap.
> 
> This whole "working device" argument is total bullshit.
> 
> If the driver was a module before, it needed a module load to become 
> working. If you could load the module, you could load the firmware. Thus 
> the transfer is non-issue.

Sometimes your responses leave me speechless! It's not only a problem of
transfer, but also a problem of selection of what to copy overthere. It
has happened to me more than once when installing a machine to proceed this
way :
  - leave the data center
  - go back to the office to find the driver somewhere
  - burn a CD with it (I once even had to feed it through a 9600 bauds Annex
    port concentrator).
  - go back to the DC and copy it from the CD. I must say that at this stage
    when you see warnings because it's not the exact same kernel version, you
    don't mind anymore and force the load in order to be able to stick an IP
    address on your machine.

Now when you load it and you see it requires a firmware, you're back to #1,
without even the certainty that the firmware you get will :
  a) be the right one
  b) work
  c) be enough
  
So please don't say that the transfer is a non-issue. It is what magnifies
the added complexity.

Instead, I would have loved to see multiboot-compatible module loading.
When your kernel does not support your fresh new RAID card and panics at
boot, you simply put the driver on a floppy (or USB stick), pre-load the
driver from GRUB and boot the kernel. I don't see how this would be possible
anymore with separate firmwares.

Don't get me wrong: I'm not against the ability to separate firmware from
modules, I'm against making that mandatory when it obviously complexifies
a lot of things without any obvious advantage in return.

> Which is just about the same thing as asking people to remember to do 
> "make modules_install" to get a working system. Yes, if you have a driver 
> as a module, you need to install that module for the device to work. Yes, 
> it's definitely "harder", but seriously..

Please don't compare an upgrade of a working desktop or developer machine with
an installation from scratch of a server in an uncomfortable location. Those
are two completely different things.

Willy


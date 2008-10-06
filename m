Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYJFTyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYJFTyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYJFTyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:54:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4145 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYJFTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:54:16 -0400
X-BigFish: VPS-58(z21eW6f5iz1432R98dR936eQ1805M936fO3117K1b0bM19c2kzzzz5a6ciz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8C1XV-01-V51-01
Date: Mon, 6 Oct 2008 21:53:50 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081006195350.GB22097@alberich.amd.com>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081006062838.GC2808@amd.corenet.prv>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Oct 2008 19:54:01.0656 (UTC) FILETIME=[47782B80:01C927ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 02:28:39AM -0400, Dmitry Torokhov wrote:
> On Sun, Oct 05, 2008 at 12:10:46PM -0700, Arjan van de Ven wrote:
> > On Sun, 5 Oct 2008 14:36:25 -0400
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > Hi,
> > > 
> > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > speed, fans are constantly on, everything seems sluggish.
> > > 
> > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > somewhere in tty_init.
> > 
> > hpet=force is a "the kernel thinks it's not wise to use, but you think
> > better"... don't do that ;(
> > 
> 
> That is not how I parse dmesg:
> 
> [    0.077927] HPET not enabled in BIOS. You might try hpet=force boot
> option
> 
> Here kernel recommends to try and enable it. If we generally don't recommed
> using 'force' I'd suggest removing the 2nd sentence from the message.

FYI.
Commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3 of tip/master is
needed to really enable hpet on SB400. I guess that patch should go
upstream asap -- and probably it's a good idea to add a check for timer
interrupt routing as well which could solve the issues on HP nx6xxx
laptops.


Regards,

Andreas



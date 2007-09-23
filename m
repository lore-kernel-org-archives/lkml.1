Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXIWKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXIWKU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXIWKUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 06:20:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:59531 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbXIWKUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 06:20:19 -0400
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200709221746.14429.mihai.dontu@gmail.com>
References: <200709220828.00078.mihai.dontu@gmail.com>
	 <200709221746.14429.mihai.dontu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Sep 2007 20:20:10 +1000
Message-Id: <1190542810.3723.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-22 at 17:46 +0300, Mihai Donțu wrote:
> On Saturday 22 September 2007, Mihai Donțu wrote:
> > Hi,
> > 
> > Today, out of curiosity, I pulled 2.6.23-rc7 (leave on the edge in a quiet weekend).
> > Anyway, it seems that radeonfb and my:
> > "01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M 5955 (PCIE)"
> > don't get along anymore, by:
> > a) X somehow fails to initialize the card and everything moves really slow (I can
> >    see how surfaces are drawn pixel-by-pixel); furthermore, garbage stuff appears
> >    on the screen;
> > b) after powering up from a s2ram, the system freezes;
> > 
> > b) is not that bad, s2ram never worked on my machine (kjournald and some other kernel
> > processes, enter disk-sleep and in a matter of seconds, everything just... freezes.
> > I can type a few commands at the normal console but that is all);
> > 
> > Following the advices in 'Documentation/power/s2ram.txt' helped. Using the regular
> > VGA console got X on the right track (no more slowness);
> > 
> > Now that I got my hands "dirty", I'm in the mood to make my s2ram work (I've
> > been using Linux (exclusively) for three years now, it's about time I do a small
> > contribution). What kernel option must I enable to determine why some processes
> > enter (and stay in) disk-sleep? I'm on a laptop and I don't think it will withstand
> > too many reboots :)
> > 
> > I've also attached the output of lspci and dmesg. Maybe someone spots something.
> > 
> > Thanks,
> > 
> 
>   Since there was no reply, I assume people *do* take the weekend off :)

Heh, yup.

There have been some radeonfb patches around -rc6 or so. Can you try
backing them out and letting us know if that helps a) ?

In that case, Linus, we probably want to revert them...

Though looking at your PCI ID (5955), I don't think the patches should
have changed anything.

Ben.



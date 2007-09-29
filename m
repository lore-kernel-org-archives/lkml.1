Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbXI2If1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbXI2If1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXI2IfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:35:20 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:44670 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXI2IfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:35:19 -0400
Date: Sat, 29 Sep 2007 10:35:16 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Adam Wysocki <gophi-lkml@chmurka.net>
Cc: linux-kernel@vger.kernel.org, giometti@enneenne.com
Subject: Re: [sdhci] mmc0: unrecognised SCR structure version 1
Message-ID: <20070929103516.3eda9bd6@poseidon.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0709290538240.5571@news.chmurka.net>
References: <Pine.LNX.4.64.0709290538240.5571@news.chmurka.net>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 05:42:37 +0200 (CEST)
Adam Wysocki <gophi-lkml@chmurka.net> wrote:

> [CCd to possibly interested Pierre Ossman and Rodolfo Giometti]
> 
> Hi there,
> 
> First, sorry for my poor english - I am not a native.
> 
> I know there have been a thread about this problem few months ago,
> but as far as I see it did not led to any results: 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/19116cafe8a20b5/4a28c3b15bb999df
> 
> I have the same problem, as described there, with Kingston 2GB SD
> card. My card reader is embedded into Fujitsu-Siemens AMILO Pro V3505
> notebook and Linux sees it as:
> 

If it's just this card, then I would have to conclude that it is indeed
broken. You'd have to return it to the store and get a new one.

(I'm afraid we can't just ignore the version field as there have been
several changes in the past where new version means no backward
compatibility.)

> 
> I have posted some debugging messages from sdhci here (ca. 44 kB): 
> http://www.chmurka.net/r/mmc-debug.txt 
> 

"Forbidden"

> PCMCIA (ide-cs) card reader does not see this card neither, but does
> not spit any error messages - just that the card is not seen
> in /proc/partitions:

That card reader probably just doesn't have a way of reporting errors
back to you.

> 
> On the other side, my Canon A610 camera sees and handles this card
> properly. Also does the usb-storage reader:
> 

I'd be very cautious about using those then. Since they obviously just
assume they can use any card you stick in there, it's a good chance
they'll start eating your data when never cards hit the market.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXKKSZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXKKSZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXKKSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:24:50 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:49312 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXKKSYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:24:48 -0500
Date: Sun, 11 Nov 2007 19:24:35 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Thorsten Leemhuis <thl@ct.heise.de>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Riki Oktarianto <rkoktarianto@gmail.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071111182435.GA2265@citd.de>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <20071109233215.GA22498@citd.de> <4735F1E8.1070009@rtr.ca> <20071110183805.GA28230@citd.de> <47370C2A.108@ct.heise.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47370C2A.108@ct.heise.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2007 15:05, Thorsten Leemhuis wrote:
> On 10.11.2007 00:32, Matthias Schniedermeyer wrote:
> >  [...]
> > My computer/mainboard @work has such a "broken" BIOS. Of the 5 
> > SATA-Ports this MB has only 1 (and 1 "missing" that is reported by
> > linux but i can't find on the MB) is configured as AHCI [...]
> 
> There is nothing "broken" here. You have a ICH8 (without R) that drives
> four SATA ports, which are handled by ata_piix.
> 
> Then you have a Jmicron JMB363 -- it handles the PATA-Channel and two
> SATA-Ports -- one internal (near the battery)/next to the PCI-Slot and a
> external eSATA port. Seems you configured it in AHCI-Mode in the
> BIOS-Setup. Linux will work just fine if you connect the hard disc to
> that port. But if you want to install Windows XP you need a driver from
> Jmicron.
> 
> There were BIOSes for the P5B where you could enabled AHCI for the ICH8
> as well. It seems Asus removed it in the later BIOS-versions again as
> Intel doesn't provide a Windows-AHCI driver for the basic ICH8.

I don't have an P5B @work, but i guess MSI cooks with water too. :-)

But i have a (1 year old) P5B @home and it is exactly like you said.

My main point is still the same, if Linux could force AHCI mode, i 
wouldn't have to switch between those modes when booting Wintendo to 
play some games. (And i could use AHCI @work where i can't switch it in 
BIOS)


On a side note, with the mainboard i had before the P5B (ASUS, 925X 
Chipset, ICH 6 or 7) Linux worked in AHCI-mode and Wintendo worked also 
without problems. (IOW: I did not need to switch modes in BIOS!)






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYIDIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYIDIrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYIDIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:47:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYIDIrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:47:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 2.6.27-rc5 cannot even boot (AMD64, quad-core, AHCI-SATA)
Date: Thu, 4 Sep 2008 10:51:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200809041015.11361@zmi.at>
In-Reply-To: <200809041015.11361@zmi.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041051.16831.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of September 2008, Michael Monnerie wrote:
> First: thanks for the nice new features all the time (I hope full XEN 
> support will be in-kernel soon).
> 
> I currently run a 2.6.26.3 kernel which works (on the machine I type 
> this e-mail). I tried 2.6.27-rc4, works too. But -rc5 does not even 
> boot, and I have no idea how to produce a log of what's happening as it 
> doesn't even find the disks.
> 
> As far as I could read on screen, there are some "PCI INT A" not 
> resettable for AHCI-SATA, and all the USB drivers do NOT load as it 
> cannot reset the controller. So even my keyboard does not work, as it's 
> USB.
> 
> The mainboard is an ABIT AX78, with an AMD Phenom(tm) 9850 Quad-Core 
> Processor, 8GB RAM. I attach a bit of hardware info (lspci, lsmod, 
> kernel-config files from 2.6.26.3 and .27-rc5), so maybe somebody finds 
> it useful.
> 
> In case of questions please contact me directly, I am not on this list.

It looks like the issue I was having with -rc5 on my Phenom box and it should
be fixed in the current mainline kernel (-rc5-git5).

Perhaps it's due to the same chipset/BIOS issue.

Thanks,
Rafael

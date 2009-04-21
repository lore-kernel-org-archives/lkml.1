Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbZDUTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbZDUTMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZDUTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:12:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZDUTMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: linux-2.6.30-rc2 - No sound (HDA Intel) avec resume
Date: Tue, 21 Apr 2009 21:11:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090421182448.270f0e10@tux.DEF.witbe.net>
In-Reply-To: <20090421182448.270f0e10@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904212111.19527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009, Paul Rolland wrote:
> Hello,

Hi,

> For the first time, I can successfully suspend/resume my Dell laptop using
> linux 2.6.30-rc2.

That's great to know. :-)

> Unfortunately, after resume, xmms stays silent. I've tried to change the
> master channel, and everything I can access in the configuration, but no
> luck.
> All other devices are resuming correctly, including the video while running
> X and compiz, so this is quite good.
> 
> Is there anything I can do to help on this issue ?
> 
> At boot time, I have :
> Advanced Linux Sound Architecture Driver Version 1.0.19.
> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> HDA Intel 0000:00:1b.0: setting latency timer to 64
> ALSA device list:
>   #0: Dummy 1
>   #1: Virtual MIDI Card 1
>   #2: HDA Intel at 0xefebc000 irq 21
> 
> When suspending :
> Apr 20 21:26:21 tux kernel: HDA Intel 0000:00:1b.0: PCI INT A disabled
> 
> When resuming :
> Apr 20 21:26:21 tux kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21

That looks pretty usual.

Please attach dmesg output including a suspend-resume cycle and /proc/iomem.

Best,
Rafael

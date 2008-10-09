Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYJJAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYJJAAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYJJAAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:00:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYJJAAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:00:37 -0400
Date: Thu, 9 Oct 2008 16:59:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27
Message-ID: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So not a lot happened after -rc9, which is mostly good. I certainly don't 
want to have any upheavals at the end of an -rc series, although I 
wouldn't have minded more people looking at the regression list. That 
said, I think we're in pretty good shape, and it's not like I can hold 
back releases indefinitely anyway.

The shortlog from -rc9 really is small, and I doubt many people will 
notice the changes. And as usual, if you want to know about the big
changes since 2.6.26, the full ChangeLog is available, but people are 
much better off with the human-readable explanations at

	http://kernelnewbies.org/LinuxChanges

but most important is obviously to just test it. Especially if you've been 
a bad boy (or girl) and haven't been testing the -rc's. 

		Linus

---
Ali Saidi (1):
      tcp: Fix possible double-ack w/ user dma

Alistair John Strachan (2):
      hwmon: (abituguru3) Enable reading from AUX3 fan on Abit AT8 32X
      hwmon: (abituguru3) Enable DMI probing feature on Abit AT8 32X

Corentin Chary (1):
      eeepc-laptop: Fix hwmon interface

Daniele Lacamera (1):
      tcp: Fix tcp_hybla zero congestion window growth with small rho and large cwnd.

Darrick J. Wong (2):
      hwmon: Define sysfs interface for energy consumption register
      hwmon: (adt7473) Fix some bogosity in documentation file

David S. Miller (2):
      Revert "ax25: Fix std timer socket destroy handling."
      ax25: Quick fix for making sure unaccepted sockets get destroyed.

Herbert Xu (1):
      net: Fix netdev_run_todo dead-lock

Jarek Poplawski (1):
      netrom: Fix sock_orphan() use in nr_release

Jean Delvare (1):
      hwmon: (it87) Prevent power-off on Shuttle SN68PT

Linus Torvalds (3):
      Revert "V4L/DVB (8904): cx88: add missing unlock_kernel"
      Don't allow splice() to files opened with O_APPEND
      Linux 2.6.27

Marcel Holtmann (3):
      [Bluetooth] Fix double frees on error paths of btusb and bpa10x drivers
      [Bluetooth] Add reset quirk for new Targus and Belkin dongles
      [Bluetooth] Add reset quirk for A-Link BlueUSB21 dongle

Matt Mackall (2):
      SLOB: fix bogus ksize calculation
      SLOB: fix bogus ksize calculation fix

Németh Márton (1):
      [CPUFREQ] correct broken links and email addresses

Patrick McHardy (1):
      net: only invoke dev->change_rx_flags when device is UP

Ralf Baechle (1):
      [MIPS] Sibyte: Register PIO PATA device only for Swarm and Litte Sur

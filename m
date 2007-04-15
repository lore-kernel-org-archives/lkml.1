Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXDOUzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXDOUzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXDOUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:55:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34183 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXDOUzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:55:24 -0400
X-Originating-Ip: 24.6.145.253
Date: Sun, 15 Apr 2007 16:55:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: so what *is* obsolete and removable?
Message-ID: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.854, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  in a recent posting, ian anderson suggested that, before kernel
features are removed, they should spend a reasonable amount of time in
the feature removal file to give everyone fair warning.  if that's the
case, then there are a *bunch* of things that should perhaps be added
to that file real soon now just to start the clock ticking.

  as a trivial first observation, there are a load of options
described as "obsolete" in one way or another in the various Kconfig
files:

$ grep -iw obsolete $(find . -name Kconfig\*)
./net/sched/Kconfig:    bool "Traffic Policing (obsolete)"
./net/netfilter/Kconfig:        bool "Layer 3 Dependent Connection tracking (OBSOLETE)"
./net/netfilter/Kconfig:          This target replaced the old obsolete QUEUE target.
./net/ipv6/netfilter/Kconfig:   tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
./net/ipv4/netfilter/Kconfig:   tristate "IP Userspace queueing via NETLINK (OBSOLETE)"
./net/ipv4/Kconfig:       This code is experimental and also obsolete. If you want to use it,
./net/bridge/netfilter/Kconfig: tristate "ebt: ulog support (OBSOLETE)"
./drivers/pcmcia/Kconfig:       bool "PCMCIA control ioctl (obsolete)"
./drivers/net/wireless/Kconfig:# Note : the cards are obsolete (can't buy them anymore), but the drivers
./drivers/net/wireless/Kconfig:comment "Obsolete Wireless cards support (pre-802.11)"
./drivers/net/Kconfig:    new card, since the 3c501 is slow, broken, and obsolete: you will
./drivers/net/Kconfig:  tristate "Traffic Shaper (OBSOLETE)"
./drivers/block/paride/Kconfig:   This option enables support for the (obsolete) EPIA parallel port
./drivers/block/paride/Kconfig:   This option enables support for the (obsolete) 90c20 parallel port
./drivers/block/Kconfig:          obsolete. For details, read <file:Documentation/ramdisk.txt>.
./drivers/sbus/char/Kconfig:    tristate "Bidirectional parallel port support (OBSOLETE)"
./drivers/sbus/char/Kconfig:      Say Y here to support Sun's obsolete variant of IEEE1284
./drivers/message/i2o/Kconfig:  bool "Enable ioctls (OBSOLETE)"
./drivers/char/Kconfig: tristate "Moxa SmartIO support (OBSOLETE)"
./drivers/char/Kconfig: tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
./drivers/mtd/chips/Kconfig:      select some other chip drivers which are now considered obsolete,
./drivers/isdn/Kconfig: tristate "Old ISDN4Linux (obsolete)"
./drivers/isdn/Kconfig:   Therefore the old ISDN4Linux layer is becoming obsolete. It is
./lib/Kconfig.debug:    bool "Enable unused/obsolete exported symbols"
./arch/i386/Kconfig:      1995 when it was made obsolete by the PCI bus.
./arch/arm/Kconfig:       1995 when it was made obsolete by the PCI bus.
./arch/sparc64/Kconfig:   1995 when it was made obsolete by the PCI bus.
./arch/m68k/Kconfig:      1995 when it was made obsolete by the PCI bus.
./arch/um/Kconfig.char:        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
./arch/um/Kconfig:      into UML. This option is largely obsolete, given that skas0 provides
./arch/mips/Kconfig:      1995 when it was made obsolete by the PCI bus.
./arch/powerpc/platforms/iseries/Kconfig:       tristate "iSeries Virtual Console Support (Obsolete)"
./arch/sh/Kconfig:        1995 when it was made obsolete by the PCI bus.
./sound/core/Kconfig:     Say Y here to support the obsolete ALSA PCM API (ver.0.9.0 rc3
./sound/oss/Kconfig:    bool "Obsolete OSS drivers"
./sound/oss/Kconfig:      This option enables support for obsolete OSS drivers that

  clearly, that was a fairly brainless search, but it still reveals a
pile of stuff that's "obsolete" (whatever that means in the context in
which it's used).  so what's really obsolete?

  as i recall, the isdn4linux was *un*obsoleted, wasn't it?  and raw
drivers are going to be kept around for a while longer.  so what's
legitimately dead?  or what should be added to the feature removal
schedule?  or, if it's not really "obsolete," perhaps it shouldn't be
described that way.

  just my $0.02 (Cdn).

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

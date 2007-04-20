Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXDTXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXDTXS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXDTXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:18:57 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57550 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXDTXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:18:56 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 20 Apr 2007 19:19:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: other potentially deletable, dead stuff
Message-ID: <Pine.LNX.4.64.0704201901470.2187@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  and while len is working on detaching APM and ACPI from legacy power
management, here's the short list of other stuff that is listed as on
its way to being dead, based on the contents of Kconfig files.  any of
this stuff candidates for removal, if not scheduling for removal?

  (note:  i made no effort to cull this list of entries that i know
folks are already aware of or might be working on, or stuff that we've
already established is *not* really obsolete.  it's just a list.)


config NET_CLS_POLICE
        bool "Traffic Policing (obsolete)"

config IP_NF_CONNTRACK_SUPPORT
        bool "Layer 3 Dependent Connection tracking (OBSOLETE)"

config IP6_NF_QUEUE
        tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"

config IP_NF_QUEUE
        tristate "IP Userspace queueing via NETLINK (OBSOLETE)"

config ARPD
        bool "IP: ARP daemon support (EXPERIMENTAL)"
        ...
        This code is experimental and also obsolete...

config BRIDGE_EBT_ULOG
        tristate "ebt: ulog support (OBSOLETE)"

config PCMCIA_IOCTL
        bool "PCMCIA control ioctl (obsolete)"

config SHAPER
        tristate "Traffic Shaper (OBSOLETE)"

config SUN_BPP
        tristate "Bidirectional parallel port support (OBSOLETE)"

config I2O_CONFIG_OLD_IOCTL
        bool "Enable ioctls (OBSOLETE)"

config MOXA_SMARTIO
        tristate "Moxa SmartIO support (OBSOLETE)"

config RAW_DRIVER
        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"

config ISDN_I4L
        tristate "Old ISDN4Linux (obsolete)"

config MODE_TT
        bool "Tracing thread support (DEPRECATED)"
        ...
        This option controls whether tracing thread support is compiled
        into UML. This option is largely obsolete ...

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

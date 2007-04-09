Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXDIOdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXDIOdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXDIOdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:33:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:38616 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753364AbXDIOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:33:07 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1923lkHabh27jhiCfGe4mGan0fx4D6grQIGaFhItc
	m+St4Q9a7DJaTU
Date: Mon, 9 Apr 2007 16:29:41 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net
Subject: 2.6.21-rc6 USB Keyboard hangs (EHCI/UHCI/HID)
Message-ID: <20070409142941.GA8178@merlin.emma.line.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: me on replies, as I read linux-kernel sporadically and am not
subscribed to linux-usb-devel at all.

Greetings,

I have seen my USB keyboard drivers lock up several times now with my M$
Natural Ergonomic Keyboard, both on SUSE 10.2's current kernel as well
as 2.6.21-rc6 today. I don't ever recall this happen with older SUSE
10.0 kernels. The keyboard is connected to a USB2.0 hub with single
transaction translator (at least that's what FreeBSD 6.2 says), which is
connected to a via root hub.

Symptoms are that the keyboard LEDs go off and no further input is
impossible (I'm typing this into a PS/2 keyboard). Replugging does not
help. Trying to unload ehci-hcd hangs modprobe, and additionally I've
got a stuck khubd (not sure if that's related), else no logging.

I'm rebuilding the kernel with HID/USB debugging cranked up to see if I
can get some detail out of the situation. Any specific kernel debugging
options that might help me debug this further?

Thanks,

-- 
Matthias Andree

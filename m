Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXHJVmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXHJVmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXHJVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:39:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:46116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754929AbXHJVj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:39:28 -0400
X-Authenticated: #441233
X-Provags-ID: V01U2FsdGVkX18/0bc/xVA/Ubcp4MPgDKrT4EtgVEsvrCETKqP66s
	4sibzfLy7AsDQz
Date: Fri, 10 Aug 2007 23:39:25 +0200
From: Michael Mauch <michael.mauch@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Subject: Serial ports rearranged in 2.6.22?
Message-ID: <20070810213925.GB10855@elmicha>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

until 2.6.21, I had the normal assignments for ttyS0 and ttyS1:

00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

With 2.6.22 I get the names <-> ports/irqs the other way around:

00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A

Is this supposed to be that way? Should we reassign these names with
udev? udev-114 doesn't seem to have built-in rules to assign the
traditional names.

Or could it be related to some brokeness in my BIOS (ACPI/PNP)? 

I'm using the 8250_pnp module (and it's the same with builtin serial
modules). I made sure that I did not accidentally change the BIOS
settings for the serial ports.

I'm using Gentoo, but on the lirc list was a Fedora user with the same
symptoms.

Regards...
		Michael

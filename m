Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXBJNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXBJNvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXBJNvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:51:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56962 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXBJNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:51:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45CDCDCD.5000609@s5r6.in-berlin.de>
Date: Sat, 10 Feb 2007 14:51:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, discuss@x86-64.org,
       linux1394-devel@lists.sourceforge.net, Bernhard Kaindl <bk@suse.de>
Subject: remote debugging via FireWire (was What will be in the x86-64/x86
 2.6.21 merge)
References: <200702101242.48467.ak@suse.de>
In-Reply-To: <200702101242.48467.ak@suse.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote at LKML:
...
> Not likely to make .21:
...
> - Early firewire support for firescope at early boot
...

Was it seen in canonical patch format on a mailinglist before?
Is it Bernhard Kaindl's ohci1394_early?
http://www.suse.de/~bk/firewire/

Would be good to put this on the usual patch-submission road in order to
prep it for 2.6.22. Could be handled via linux1394-2.6.git, although a
different channel where the actual users of this facility watch would
IMO be more appropriate.

I also have suggestions, at least WRT Bernhard's code:
  - The Kconfig option could go into the "Kernel hacking" submenu rather
    than the IEEE 1394 submenu. (The driver source should stay in
    drivers/ieee1394.)
  - Leave a note in the Kconfig help how it is typically used, i.e. what
    is required on the remote terminal side, where to find firescope,
    fireproxy etc. and assorted HOWTOs.
  - Indicate in the Kconfig help that only a 4GB address range is made
    visible this way.

A mostly unrelated note: A simple to set up remote-dmesg utility would
be nice to have on the terminal side. Maybe a small ieee1394 high-level
driver which gives hints on the location of the dmesg buffer via
configuration ROM would be warranted. Or is it feasible to find the
dmesg buffer by plain memory analysis?
-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/

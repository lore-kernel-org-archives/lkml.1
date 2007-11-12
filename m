Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbXKMAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbXKMAA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXKMAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:00:18 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:56316 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXKMAAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:00:17 -0500
X-Greylist: delayed 1442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 19:00:17 EST
Message-ID: <4738E36E.4090706@tlinx.org>
Date: Mon, 12 Nov 2007 15:36:14 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: auto-reboot "broken" in 2.6.23.1 (from 2.6.22.12)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I upgraded the kernel on a multi-cpu Dell workstation (690) to
2.6.23.1.  It had been running at 2.6.20.  I moved to the new kernel via 
"make oldconfig" -- choosing defaults.  That didn't work.

To narrow things down I tried it under 2.6.21.1 (made
oldconfig from working 2.6.20/proc/config.gz).  This worked.
Downloaded and made 2.6.22.12 (w/oldconfig from the
working 2.6.21.1 config).

Tried deriving a new config from the 2.6.22.12/proc/config.gz
that worked (using make oldconfig).  This kernel won't reboot.
It goes through the entire shutdown process, and says it is
about to reboot the system.  Then it just stops. 

One of the new questions on ".23", was suspend-to-ram support.
That defaulted to 'yes' in oldconfig -- tried 'no' (thinking
maybe it was related), but that made no difference.

I assume something is unique to my configuration, but don't
know what would have changed in machine shutdown that would
have affected my system.  I also tried compiling in APM
and telling it to use real-mode to try to power-off the machine
(thinking, maybe, that flag might also affect rebooting; made
no difference).

I can post the config if that helps, but didn't want to include
a bunch of superfluous info if it wasn't needed.

Thanks,
Linda



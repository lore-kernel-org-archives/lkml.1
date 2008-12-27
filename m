Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYL0Tvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYL0Tvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYL0Tvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:51:32 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:55200 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYL0Tvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:51:31 -0500
Message-ID: <38153.166.70.238.44.1230404757.squirrel@webmail.wolfmountaingroup.com>
Date: Sat, 27 Dec 2008 12:05:57 -0700 (MST)
Subject: [ANNOUNCE] ndiswrapper 1.54 for Linux 2.6.28 Released
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.28.tar.gz

The breakage during unload and subsequent kernel corruption has been
tracked down to link_watch.c and the packet scheduler code and is due to
list corruption in dev_deactivate() being called with an invalid netdev
context.

The linkwatch code is not called by ndiswrapper and the problems are due
to poor error checking and cleanup in Linux proper with network drivers. 
As such, ndiswrapper for 2.6.28 is posted as released based upon input
from other folks.  Thanks to those folks who downloaded and tested the
code and provided feedback for this release.

The Native Linux wireless drivers and the hacked up pseudo-pirated
microcode they rely on still do not work properly on most of my laptop
wireless drivers or are very flaky for the BCM based drivers and Intel
3945 series drivers in 2.6.28.  ndiswrapper almost a required component in
order to use wireless with Linux on a large number of laptops.    I see no
way around the current vendors offerings which are heavily dependent on
internal and proprietary microcode without ndiswrapper since the Linux
drivers are essentially impossible to keep working.

Since most people (me included) are not interested in engaging in piracy
by using tools which lift microcode and firmware images from ndis drivers,
ndiswrapper seems a reasonable compromise since any customer who purchases
a card with ndis based drivers has a legal right to use them as ndis
drivers.

Cutting and pasting firmware seems too much like piracy, not to mention
being a great big hassle.

Jeff





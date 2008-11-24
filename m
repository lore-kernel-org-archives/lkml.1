Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYKXVWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYKXVWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYKXVW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:22:28 -0500
Received: from eazy.amigager.de ([213.239.192.238]:43691 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYKXVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:22:27 -0500
Date: Mon, 24 Nov 2008 22:22:25 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: 2.6.28-rc regression: digital audio inactive after resume from
	suspend
Message-ID: <20081124212225.GA5872@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org, tiwai@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the digital audio out (optical) is inactive (no red light, and
therefore silent) after resume from suspend on my Mac mini Core Duo.
When I disable and enable the IEC958 toggle, it works again.

This didn't happen with 2.6.27. Currently, I use 2.6.28-rc6 as of
commit ged31348.

This is the hardware in lspci:

00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family)
High Definition Audio Controller [8086:27d8] (rev 02)
	Subsystem: Sigmatel Device [8384:7680]
	Flags: bus master, fast devsel, latency 0, IRQ 22
	Memory at 90440000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

The dmesg output with 2.6.27 and 2.6.28-rc are here:

http://tikei.de/dmesg_2.6.27.5
http://tikei.de/dmesg_2.6.28-rc6

Regards,
Tino

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZCYGpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZCYGpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZCYGpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:45:06 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49615 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZCYGpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:45:05 -0400
Date: Wed, 25 Mar 2009 07:45:03 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: Resume failure: ata3.01: revalidation failed (errno=-2)
Message-ID: <20090325064503.GA4959@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried if I can get reliable suspend to RAM on my new Mac mini Core 2
Duo using 2.6.29, and did a "burn in" test with an endless
suspend/resume loop using RTC wakeup. After ~30 attempts, the kernel
hangs with a screen full of this message:

ata3.01: revalidation failed (errno=-2)

In the kernel log, I see _one_ occurrence of this message at each resume:

kern.debug: ata3.01: NODEV after polling detection
kern.err: ata3.01: revalidation failed (errno=-2)

I tried the same using 2.6.27.20 and got the same, after 52 attempts.

The full kernel log is here:

http://tikei.de/kernlog.txt

This is the SATA device:

00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7
Family) SATA IDE Controller [8086:27c4] (rev 02)

Any hints how I can fix or debug this? It looks like a generic message
that only shows that something is wrong in a much deeper layer. Maybe I
should add some debugging to ata_dev_revalidate().

Regards,
Tino

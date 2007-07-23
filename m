Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbXGWHlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbXGWHlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGWHlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:41:04 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38012 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXGWHlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:41:03 -0400
Message-ID: <46A45B65.9000704@s5r6.in-berlin.de>
Date: Mon, 23 Jul 2007 09:40:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net>
In-Reply-To: <20070723063741.GA32240@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> I too experience these bugs with the new fw stack; this time with a TI
> OHCI-1394a combo chip in 2 different laptops and a Via 1394 pci addon card.
> The target is a an external hd enclosure with an Oxford Semi chip.

Thanks for the info.  Then there is definitely a driver problem.  It is
essential that I (and Kristian) find a way to reproduce it.

I have 4 test PCs but use only one of them regularly.  Testing takes
time...  So far I did almost all high-volume tests on Core 2 Duo/ i945,
kernel compiled for 32bit SMP Preempt.  I have 6 different FireWire
cards which I could test in it (right now at most 3 at once; usually I
only test 1 at once).  Sometimes I use a Core 2 Duo/ i945, 64bit SMP
Preempt, with only one card which I can't swap.  Very rarely I test an
Athlon/ KM266, kernel compiled for UP non-preempt.  I've also got an
ancient Pentium MMX notebook on which I have yet to install a new distro
before I can test it reliably.

According to Andreas' report, I suppose I should do high-volume tests on
the Athlon now.

On my main machine, I only saw very rare and recoverable "status write
for unknown orb" errors (one during many hours of continuous I/O).  I
have 10 or so different SBP-2 devices but only test few of them
regularly.  They all work for me, except for 100% login failures on an
old CD-R/W and fw-sbp2's inability to access the 2nd logical unit of the
one dual-LU device of mine.  (Multi LU capability should be added soon.)

I always only test vanilla kernels (with ieee1394/firewire patches).  I
wanted to start testing -rt kernels because they are known to make bugs
of the old ieee1394 drivers more visible, but simply didn't find the
time to do such tests yet.
-- 
Stefan Richter
-=====-=-=== -=== =-===
http://arcgraph.de/sr/

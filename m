Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHJSYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHJSYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZHJSYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:24:31 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1969 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZHJSYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:24:30 -0400
Message-ID: <4A806529.3060609@caviumnetworks.com>
Date: Mon, 10 Aug 2009 11:21:29 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] New hardware RNG for Octeon SOCs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 18:21:30.0174 (UTC) FILETIME=[61C23DE0:01CA19E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behold the Random Number Generator driver for Octeon!

The first patch adds some port definitions and the octeon_rng platform
device.  The second is the driver.

I am copying AKPM and Linus as there seems to be no hw_random maintainer.

Since Octeon is a mips port, we might want to merge both patches via
Ralf's tree.

Comments?

David Daney (2):
   MIPS: Octeon:  Add hardware RNG platform device.
   hw_random: Add hardware RNG for Octeon SOCs.

  arch/mips/cavium-octeon/setup.c              |   44 ++++++++
  arch/mips/include/asm/octeon/cvmx-rnm-defs.h |   86 +++++++++++++++
  drivers/char/hw_random/Kconfig               |   13 +++
  drivers/char/hw_random/Makefile              |    1 +
  drivers/char/hw_random/octeon-rng.c          |  146 
++++++++++++++++++++++++++
  5 files changed, 290 insertions(+), 0 deletions(-)
  create mode 100644 arch/mips/include/asm/octeon/cvmx-rnm-defs.h
  create mode 100644 drivers/char/hw_random/octeon-rng.c


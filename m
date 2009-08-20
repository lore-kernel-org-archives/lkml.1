Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZHTVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZHTVJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZHTVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:09:07 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:39465 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZHTVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:09:06 -0400
Message-ID: <4A8DBB17.5020301@caviumnetworks.com>
Date: Thu, 20 Aug 2009 14:07:35 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ralf@linux-mips.org, mpm@selenic.com, herbert@gondor.apana.org.au
CC: linux-mips@linux-mips.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] New hardware RNG for Octeon SOCs (v2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2009 21:07:35.0521 (UTC) FILETIME=[3DB30510:01CA21DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on feedback from AKPM, I have a new revision of the Octeon
hardware RNG driver.

The changes from v1 are minor, just eliminating some bogus casting by
accessing the driver state by embedding struct hwrng in the driver
data, which is now accessed with the container_of() trick.

The first patch adds some port definitions and the octeon_rng platform
device.  The second is the driver.

Since Octeon is a mips port, we might want to merge both patches via
Ralf's linux-mips.org tree.

David Daney (2):
   MIPS: Octeon:  Add hardware RNG platform device.
   hw_random: Add hardware RNG for Octeon SOCs.

  arch/mips/cavium-octeon/setup.c              |   43 ++++++++
  arch/mips/include/asm/octeon/cvmx-rnm-defs.h |   88 +++++++++++++++
  drivers/char/hw_random/Kconfig               |   13 +++
  drivers/char/hw_random/Makefile              |    1 +
  drivers/char/hw_random/octeon-rng.c          |  147 
++++++++++++++++++++++++++
  5 files changed, 292 insertions(+), 0 deletions(-)
  create mode 100644 arch/mips/include/asm/octeon/cvmx-rnm-defs.h
  create mode 100644 drivers/char/hw_random/octeon-rng.c


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZDVKsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZDVKsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZDVKsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:48:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40417
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbZDVKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:48:13 -0400
Date: Wed, 22 Apr 2009 03:48:05 -0700 (PDT)
Message-Id: <20090422.034805.63377383.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this device probing bug fix and defconfig
updates for Sparc.

Thanks!

The following changes since commit 091069740304c979f957ceacec39c461d0192158:
  Linus Torvalds (1):
        Linux 2.6.30-rc3

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Update defconfig.
      sparc32: Update defconfig.
      sparc: Fix bus type probing for ESP and LE devices.

 arch/sparc/configs/sparc32_defconfig |   98 +++++++++++++------
 arch/sparc/configs/sparc64_defconfig |  182 ++++++++++++++++++++++------------
 arch/sparc/kernel/of_device_32.c     |   21 ++++-
 arch/sparc/kernel/of_device_64.c     |   21 ++++-
 4 files changed, 225 insertions(+), 97 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZH0De3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZH0De3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZH0De2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:34:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:49572 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZH0De1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:34:27 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 13:33:48 +1000
Message-Id: <1251344028.20467.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of last minute patches for 2.6.31. One is a regression fix
(afaik) where a PS3 driver gets incorrectly loaded on other platforms and
crashes, along with a PS3 defconfig update.
The following changes since commit f415c413f458837bd0c27086b79aca889f9435e4:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Geert Uytterhoeven (1):
      powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device registration

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

 arch/powerpc/configs/ps3_defconfig |  211 +++++++++++++-----------------------
 arch/powerpc/platforms/ps3/time.c  |    4 +
 2 files changed, 79 insertions(+), 136 deletions(-)




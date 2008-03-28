Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYC1AQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYC1AQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYC1AQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:16:22 -0400
Received: from ozlabs.org ([203.10.76.45]:53026 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbYC1AQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:16:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio_pci rmmod fix and lguest documentation/comment updates
Date: Fri, 28 Mar 2008 11:16:10 +1100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281116.10314.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3085354de635179d70c240e6d942bcbd1d93056c:
  Ingo Molnar (1):
        x86: prefetch fix #2

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Anthony Liguori (1):
      virtio_pci: unregister virtio device at device remove

Paul Bolle (1):
      lguest: lguest.txt documentation fix

Rusty Russell (2):
      lguest: Don't need comment terminator before disk section.
      lguest: comment documentation update.

Tim Ansell (1):
      lguest: Add puppies which where previously missing.

 Documentation/lguest/lguest.c         |   70 ++++++++++++----------
 Documentation/lguest/lguest.txt       |   19 ++++--
 arch/x86/lguest/boot.c                |  108 +++++++++++++++++++--------------
 arch/x86/lguest/i386_head.S           |   15 +++-
 drivers/lguest/Makefile               |    8 +++
 drivers/lguest/core.c                 |   18 +++---
 drivers/lguest/hypercalls.c           |   11 +++-
 drivers/lguest/interrupts_and_traps.c |    7 +-
 drivers/lguest/lguest_device.c        |   11 ++--
 drivers/lguest/lguest_user.c          |   30 ++++++---
 drivers/lguest/page_tables.c          |   32 ++++++----
 drivers/lguest/x86/core.c             |   33 ++++++----
 drivers/lguest/x86/switcher_32.S      |    8 +-
 drivers/virtio/virtio_pci.c           |    1 +
 include/asm-x86/lguest_hcall.h        |    2 +-
 include/linux/lguest_launcher.h       |    6 ++-
 16 files changed, 229 insertions(+), 150 deletions(-)

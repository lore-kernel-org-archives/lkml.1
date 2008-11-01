Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYKAAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYKAAMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 20:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYKAAMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 20:12:01 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:50408 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYKAAMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 20:12:01 -0400
Date: Sat, 1 Nov 2008 01:11:50 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC git pull 2/2] Remove CRIS build links
Message-ID: <20081101001150.GX4608@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031235849.GW4608@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Again, I know this is a bit late in the game, thus the RFC, but I felt it
would be useful to have these changes in 2.6.28, and Sam Ravnborg
also encouraged me to get these in asap.

This second pull request contains two changes dependent on the first
pull request.

These two changes remove all uses of symbolic links in the CRIS port, making
it possible to build two CRIS architectures (with different O= parameters)
in parallell using the same source tree.


Please consider pulling the following changes since commit
556dcee7b829e5c350c3ffdbdb87a8b15aa3c5d3:
  Jesper Nilsson (1):
        [CRIS] Move header files from include to arch/cris/include.

are available in the git repository at:

      git://www.jni.nu/cris.git link_removal

Jesper Nilsson (2):
      [CRIS] Merge asm-offsets.c for both arches into one file.
      [CRIS] Remove links from CRIS build

 arch/cris/Makefile                            |   67 +++++----------
 arch/cris/arch-v10/kernel/asm-offsets.c       |   47 ----------
 arch/cris/arch-v10/vmlinux.lds.S              |  118 -------------------------
 arch/cris/arch-v32/boot/compressed/head.S     |   16 +++-
 arch/cris/arch-v32/kernel/head.S              |   20 ++++-
 arch/cris/{arch-v32 => }/kernel/asm-offsets.c |   51 +++++++----
 arch/cris/{arch-v32 => kernel}/vmlinux.lds.S  |   44 +++++++---
 7 files changed, 117 insertions(+), 246 deletions(-)
 delete mode 100644 arch/cris/arch-v10/kernel/asm-offsets.c
 delete mode 100644 arch/cris/arch-v10/vmlinux.lds.S
 rename arch/cris/{arch-v32 => }/kernel/asm-offsets.c (55%)
 rename arch/cris/{arch-v32 => kernel}/vmlinux.lds.S (73%)


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com

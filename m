Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbYGRNRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbYGRNRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYGRNQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:16:55 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:40840 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbYGRNQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:16:55 -0400
Date: Fri, 18 Jul 2008 15:16:40 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [git pull] CRIS update for 2.6.27
Message-ID: <20080718131640.GF9127@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The following changes since commit 543cf4cb3fe6f6cae3651ba918b9c56200b257d0:
  Linus Torvalds (1):
        Linux 2.6.26-rc8

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Hinko Kocevar (1):
      cris: compile fixes for 2.6.26-rc5

Jesper Nilsson (10):
      [CRIS] Build fixes for compressed and rescue images for v10 and v32:
      Merge branch 'cris_debug_port_fix' into cris
      Merge branch 'pcf8563_mutex_spinlock' into cris
      [CRIS] Correct image makefiles to allow using a separate OBJ-directory.
      [CRIS] Correct definition of subdirs for install_headers.
      [CRISv10] Correct whitespace damage.
      [CRISv10] Clean up compressed/misc.c
      Merge branch 'build_fix' into cris
      Merge branch 'asm_cris_kbuild' into cris
      Merge branch 'cris_debug_port_fix' into cris

Julia Lawall (1):
      It looks at least odd to apply spin_unlock to a mutex.

 arch/cris/arch-v10/boot/Makefile                 |    1 -
 arch/cris/arch-v10/boot/compressed/Makefile      |   14 +--
 arch/cris/arch-v10/boot/compressed/decompress.ld |    3 +-
 arch/cris/arch-v10/boot/compressed/head.S        |   98 ++++++++--------
 arch/cris/arch-v10/boot/compressed/misc.c        |  144 ++++++++++++----------
 arch/cris/arch-v10/boot/rescue/Makefile          |    9 +-
 arch/cris/arch-v10/drivers/pcf8563.c             |    2 +-
 arch/cris/arch-v10/kernel/debugport.c            |   20 ++-
 arch/cris/arch-v32/boot/Makefile                 |    1 -
 arch/cris/arch-v32/boot/compressed/Makefile      |    6 +-
 arch/cris/arch-v32/boot/rescue/Makefile          |    3 +-
 arch/cris/arch-v32/drivers/pcf8563.c             |    2 +-
 include/asm-cris/Kbuild                          |    5 +-
 13 files changed, 154 insertions(+), 154 deletions(-)


This update makes the CRIS port compile using only the
cris-axis-linux-gnu toolchain, removing the need for cris-axis-elf.
It also makes it possible to compile using make O= flag and fixes
some other obvious bugs.


Sorry about the "Merge branch" noise, I'll try to avoid them in the future.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com

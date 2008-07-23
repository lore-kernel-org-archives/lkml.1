Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYGWAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYGWAO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYGWAOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:14:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59691
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbYGWAOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:14:48 -0400
Date: Tue, 22 Jul 2008 17:14:48 -0700 (PDT)
Message-Id: <20080722.171448.05499825.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc updates, thanks a lot!

The following changes since commit e4f25060b87a627f5cda84b8134911d43c919458:
  David Howells (1):
        sparc: Remove Sparc's asm-offsets for sclow.S

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Bartlomiej Zolnierkiewicz (4):
      ide: <asm-sparc/ide_64.h>: use %r0 for outw_be()
      ide: <asm-sparc/ide_32.h>: use __raw_{read,write}w()
      ide: <asm-sparc/ide_64.h>: use __raw_{read,write}w()
      ide: merge <asm-sparc/ide_64.h> with <asm-sparc/ide_32.h>

David S. Miller (2):
      sparc64: Do not define BIO_VMERGE_BOUNDARY.
      sparc: Fixes the DRM layer build on sparc.

Stephen Rothwell (1):
      sparc32: pass -m32 when building vmlinux.lds

 arch/sparc/Makefile        |    1 +
 include/asm-sparc/ide.h    |  102 ++++++++++++++++++++++++++++++++++++--
 include/asm-sparc/ide_32.h |   95 -----------------------------------
 include/asm-sparc/ide_64.h |  118 --------------------------------------------
 include/asm-sparc/io_32.h  |    1 +
 include/asm-sparc/io_64.h  |    2 +-
 6 files changed, 100 insertions(+), 219 deletions(-)
 delete mode 100644 include/asm-sparc/ide_32.h
 delete mode 100644 include/asm-sparc/ide_64.h

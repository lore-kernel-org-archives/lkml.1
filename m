Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752167AbYLRPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbYLRPjU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLRPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:39:07 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51647 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbYLRPjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:39:06 -0500
Date: Thu, 18 Dec 2008 16:38:49 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        AVR32 Linux Kernel <kernel@avr32linux.org>
Subject: [GIT PULL] AVR32 fixes
Message-ID: <20081218163849.5e6a07d9@hskinnemoen-d830>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git fixes

to get the following last-minute fixes for AVR32. Most of it is a
defconfig update for ATSTK1006 enabling JFFS2 write buffering support,
without which it can't boot from a JFFS2 file system stored in NAND
flash.

There's also a fix/workaround for a new "feature" in binutils 2.18
which causes it to build unbootable kernel images.

Anders Blomdell (1):
      avr32: Enable pullup on USART TX lines

Haavard Skinnemoen (2):
      ATSTK1006: Fix boot from NAND flash
      avr32: favr-32 build fix

Hans-Christian Egtvedt (1):
      avr32: remove .note.gnu.build-id section when making vmlinux.bin

 arch/avr32/boards/favr-32/flash.c      |    2 +-
 arch/avr32/boards/favr-32/setup.c      |    8 +-
 arch/avr32/boot/images/Makefile        |    2 +-
 arch/avr32/configs/atstk1006_defconfig |  134 +++++++++++++++++++++++---------
 arch/avr32/mach-at32ap/at32ap700x.c    |    8 +-
 5 files changed, 107 insertions(+), 47 deletions(-)

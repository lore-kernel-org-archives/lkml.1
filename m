Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZCXIgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZCXIgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZCXIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:36:22 -0400
Received: from relay.atmel.no ([80.232.32.139]:65323 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZCXIgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:36:22 -0400
Date: Tue, 24 Mar 2009 09:35:08 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AVR32 update
Message-ID: <20090324093508.3401c547@hskinnemoen-d830>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following updates.

Ben Nizette (1):
      avr32: Fix out-of-range rcalls in large kernels

Haavard Skinnemoen (1):
      avr32: fix out-of-range rjmp instruction on large kernels

Huang Weiyi (1):
      avr32: remove duplicated #include

 arch/avr32/boards/hammerhead/flash.c |    1 -
 arch/avr32/include/asm/uaccess.h     |    8 ++--
 arch/avr32/kernel/entry-avr32b.S     |   60 +++++++++++++++++-----------------
 arch/avr32/kernel/syscall-stubs.S    |   14 ++++----
 arch/avr32/lib/strnlen_user.S        |    2 +-
 5 files changed, 42 insertions(+), 43 deletions(-)

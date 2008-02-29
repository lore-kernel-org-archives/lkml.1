Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYB2Nrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYB2Nrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYB2NrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:47:25 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54357 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281AbYB2NrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:47:25 -0500
Date: Fri, 29 Feb 2008 14:46:33 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes
Message-ID: <20080229144633.6cd169ee@hskinnemoen.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git avr32-fixes

to receive the following fixes.

Haavard Skinnemoen (5):
      AVR32: Define PAGE_SHARED
      avr32: Fix broken pte dump code in do_page_fault()
      avr32: Use correct config symbol in atstk1004 board code
      avr32: Call tick_nohz_{stop,restart}_sched_tick() in idle loop
      avr32: Fix OCD refcounting bug

 arch/avr32/boards/atstk1000/atstk1004.c |    2 +-
 arch/avr32/kernel/process.c             |    4 ++++
 arch/avr32/mm/fault.c                   |    2 ++
 include/asm-avr32/pgtable.h             |    1 +
 4 files changed, 8 insertions(+), 1 deletions(-)

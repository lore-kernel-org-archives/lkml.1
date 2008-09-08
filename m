Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYIHNTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYIHNTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIHNTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:19:00 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49966 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYIHNTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:19:00 -0400
Date: Mon, 8 Sep 2008 15:18:26 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes for 2.6.27
Message-ID: <20080908151826.718b5117@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2008 13:18:21.0179 (UTC) FILETIME=[5D79DCB0:01C911B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following two fixes.

Haavard Skinnemoen (1):
      avr32: Fix lockup after Java stack underflow in user mode

Humphrey Bucknell (1):
      avr32: pm_standby low-power ram bug fix

 arch/avr32/kernel/asm-offsets.c        |    6 +++
 arch/avr32/kernel/entry-avr32b.S       |   59 ++++++++++++++++++++++++++++++-
 arch/avr32/mach-at32ap/pm-at32ap700x.S |    2 +-
 3 files changed, 64 insertions(+), 3 deletions(-)

Haavard

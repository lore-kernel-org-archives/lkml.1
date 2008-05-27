Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYE0IlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYE0IlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYE0Iku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:40:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:55341 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbYE0Iks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:40:48 -0400
Date: Tue, 27 May 2008 10:17:13 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes
Message-ID: <20080527101713.61c891dd@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2008 08:17:08.0208 (UTC) FILETIME=[0E2F5700:01C8BFD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'master' branch of

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the below fixes.

Adrian, sorry about sitting on your fixes for so long. You can close
bug #10733 after this is merged.

Oh, and my 'master' branch has been a non-working mess for such a long
time now that I decided to reset it. From now on, I'll only add stuff
to it that I expect to go upstream fairly quickly, and never rebase it.
Experimental drivers and other in-progress stuff will go into the
atmel-X.Y.Z branches which are created from scratch for each point
release. In-progress but mostly safe avr32 arch stuff will go into
avr32-arch, which is included in linux-next.

Adrian Bunk (2):
      avr32: export copy_page
      avr32: export strnlen_user

Haavard Skinnemoen (2):
      avr32: Update defconfigs
      avr32: Fix cpufreq oops when ondemand governor is default

 arch/avr32/configs/atngw100_defconfig  |  336 ++++++++++++++++----------------
 arch/avr32/configs/atstk1002_defconfig |  241 ++++++++++++++++-------
 arch/avr32/configs/atstk1003_defconfig |  158 ++++++++++-----
 arch/avr32/configs/atstk1004_defconfig |  110 +++++++----
 arch/avr32/kernel/avr32_ksyms.c        |    4 +
 arch/avr32/mach-at32ap/cpufreq.c       |    3 +-
 6 files changed, 521 insertions(+), 331 deletions(-)

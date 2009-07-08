Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZGHLof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZGHLof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZGHLo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:44:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbZGHLo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:44:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes for 2.6.31
Date: Wed, 8 Jul 2009 13:44:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Peter Chubb <peterc@nicta.com.au>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081344.46581.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

This will fix a regression introduced by the recent arch/x86/power/cpu_(32|64)
unification (http://bugzilla.kernel.org/show_bug.cgi?id=13661) and a bug
in drivers/base/power/main.c causing suspend to fail when it should succeed.

 arch/x86/power/Makefile   |    2 +-
 drivers/base/power/main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

---------------

Peter Chubb (1):
      x86: Fix resume from suspend when CONFIG_CC_STACKPROTECTOR

Sebastian Ott (1):
      PM: Clear -EAGAIN in dpm_prepare


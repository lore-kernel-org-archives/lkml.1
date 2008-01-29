Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYA2XQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYA2XQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYA2XQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:16:16 -0500
Received: from mail.queued.net ([207.210.101.209]:3853 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYA2XQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:16:15 -0500
Date: Tue, 29 Jan 2008 18:17:14 -0500
From: Andres Salomon <dilinger@queued.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: jordan.crouse@amd.com, linux-kernel@vger.kernel.org
Subject: [git pull] geode updates
Message-ID: <20080129181714.33c61d80@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Can you please pull from the following?  It's a bunch of Geode cleanups and fixes.


  git://git.infradead.org/geode.git for-tglx

Andres Salomon (5):
      GEODE: MFGPT: Minor cleanups
      GEODE: MFGPT: drop module owner usage from MFGPT API
      GEODE: MFGPT: replace 'flags' field with 'avail' bit
      GEODE: MFGPT: make mfgpt_timer_setup available outside of mfgpt_32.c
      GEODE: MFGPT: fix a potential race when disabling a timer

Jordan Crouse (2):
      GEODE: MFGPT: Use "just-in-time" detection for the MFGPT timers
      x86:  make sure the right MFGPT timer fired the timer tick

Willy Tarreau (1):
      x86: GEODE fix MFGPT input clock value

 arch/x86/kernel/geode_32.c |    5 -
 arch/x86/kernel/mfgpt_32.c |  121 +++++++++++++++++++++++----------------------
 include/asm-x86/geode.h    |    9 ++-
 3 files changed, 72 insertions(+), 63 deletions(-)

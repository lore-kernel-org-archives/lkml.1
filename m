Return-Path: <linux-kernel-owner+w=401wt.eu-S937342AbYEUVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937342AbYEUVJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937190AbYEUVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:09:28 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63907 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937125AbYEUVJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:09:27 -0400
Date: Wed, 21 May 2008 22:08:55 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] x86: Timer through APIC and related clean-ups
Message-ID: <Pine.LNX.4.55.0805212158350.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 This is a set of patches replacing patch-2.6.26-rc1-20080505-timer_ack-1
and patch-2.6.26-rc1-20080505-timer-8259-0 sent previously.  The patches
have been split up into smaller logically self-contained chunks to make
tracking down problems easier.

 The patch-2.6.26-rc1-20080505-nosmp-watchdog-0 change fixes a problem
with timer interrupts getting masked in the 8259A as a result of
patch-2.6.26-rc1-20080505-timer-8259-6 in the corner-case scenario of
"nmi_watchdog=1 nosmp" being passed at the command line.

 As there are some interdependencies the patches are best applied in the 
order I am sending them; see also the paragraph above.

  Maciej

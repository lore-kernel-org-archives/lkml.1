Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbXL2Uio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbXL2Uio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXL2Uih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:38:37 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38021 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbXL2Uig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:38:36 -0500
Date: Sat, 29 Dec 2007 21:38:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] x86 makefile unification and cleaning
Message-ID: <20071229203836.GA21020@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since first posting I have updated the patch like this:
o Fixed a few bugs shown up by more extensive testing
o Avoided one ifdef group
o Added a few more comments
o Removed and/or updated a few comments

On top of that I did a few more patches:

Sam Ravnborg (5):
      x86: unification of arch/x86/Makefiles
      x86: share more options between 32 and 64 bit build
      x86: biarch support for 32 bit builds beautified
      x86: teach vdso to clean
      x86: teach vdso to clean

The resulting diffstat:
 arch/x86/Makefile      |  244 +++++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/Makefile_32   |  181 -----------------------------------
 arch/x86/Makefile_64   |  141 ----------------------------
 arch/x86/boot/Makefile |    4 +-
 arch/x86/vdso/Makefile |    2 +
 5 files changed, 243 insertions(+), 329 deletions(-)

I'm pretty satisfied with the result.
But I hope someone can look into the cpu specific stuff
and merge the remaining bits from 64 bit to the currently 32 bit
only Makefile_32.cpu file.

This will benefit readability and UML I think.

The patches are made on top of the mm branch of the x86 tree.

Patches follows.

	Sam


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZBZEHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZBZEHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBZEHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:07:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:45858 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZBZEHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:07:43 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 15:07:24 +1100
Message-Id: <1235621244.8805.340.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please pull a few regression fixes for powerpc.

Cheers,
Ben.

The following changes since commit 169d418b127b98a3e464e9c4b807ad083760f98c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Mark Nelson (2):
      powerpc: Fix 64bit memcpy() regression
      powerpc: Fix 64bit __copy_tofrom_user() regression

Michael Neuling (1):
      powerpc: Fix load/store float double alignment handler

 arch/powerpc/kernel/align.c    |   29 +++++++++++++----------------
 arch/powerpc/lib/copyuser_64.S |   38 +++++++++++++++++++++++++++++++-------
 arch/powerpc/lib/memcpy_64.S   |   26 ++++++++++++++++++++------
 3 files changed, 64 insertions(+), 29 deletions(-)



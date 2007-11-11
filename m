Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXKKBEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXKKBEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 20:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXKKBEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 20:04:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40432 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXKKBEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 20:04:38 -0500
Date: Sat, 10 Nov 2007 20:04:35 -0500
Message-Id: <200711110104.lAB14ZCl018085@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: patch conflicts (MMOTM "10-Nov-2007 22:46")
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46".

1. I was getting a bunch of patch conflicts, until I realized that this
   latest set of patches was to be applied against 2.6.24-rc2 (your mm.patch
   gave it away :-) The last snapshot was against 2.6.24-rc1.

   What should be the official way in which people using the above URL know
   which base to apply it against: is looking at mm.patch OK?  If so, then
   I'd like to suggest that you move mm.patch to the very beginning of your
   series file: that way if the first patch causes a conflict, it'd be a
   hint to the person to investigate why, and mm.patch is fairly clear about
   it (moreso than when any other patch will fail to apply).

2. A related question: if someone uses the above URL for mm patches, how
   should they report a unique identifier (ala git-describe)?

3. I still have patch conflicts, with this series of patches:

Applying patch..suppress-aout-library-support-if-config_binfmt_aout.patch
error: patch failed: arch/m68k/kernel/process.c:316
error: arch/m68k/kernel/process.c: patch does not apply
Context reduced to (2/2) to apply fragment at 120
error: patch failed: fs/binfmt_elf.c:961
error: fs/binfmt_elf.c: patch does not apply
error: patch failed: include/linux/Kbuild:17
error: include/linux/Kbuild: patch does not apply

I also had to comment out these two due to new or dependent conflicts:

suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
make-frame_pointer-default=y.patch

4. With the above 3 patches not applied, I got a couple of compile errors,
   which I reported separately.

Cheers,
Erez.

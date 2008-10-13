Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYJMIQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYJMIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYJMIQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:16:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15467 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYJMIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f/hGrjqUSMkXpfAgQ/BelvU/NBrU/bumhkwbCxPjJ01L+hkaesFMdr4OcYfF4hiNPN
         kF4MyWX17zwz7VvvVyUt6QwdxYP/z9n6B2jCuMLMeuF0GCJ7fgVyOAOqrfX2gvjyyJHh
         bhKu/lG1ruLrb94mNG5CWz6gPeBxgx6tOcISc=
Date: Mon, 13 Oct 2008 12:19:08 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] /proc
Message-ID: <20081013081908.GA19572@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please, pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc

to get
a) oops fix for rare race condition
b) /proc/*/personality files
c) removal of kernel.maps_protect sysctl which stopped controlling anything
   since 2.6.24-rc7 (effectively was always turned on)

and misc cleanups not worth mentioning.

 Documentation/filesystems/proc.txt |    7 -------
 arch/arm/kernel/dma.c              |   17 -----------------
 arch/sparc/include/asm/dma_32.h    |    1 -
 fs/proc/Kconfig                    |   10 ++++++++++
 fs/proc/array.c                    |    7 -------
 fs/proc/base.c                     |   21 ++++++++++-----------
 fs/proc/inode.c                    |    2 +-
 fs/proc/internal.h                 |    2 --
 fs/proc/proc_misc.c                |    1 -
 fs/proc/proc_sysctl.c              |    6 +++---
 fs/proc/task_mmu.c                 |   16 +---------------
 fs/proc/task_nommu.c               |    5 -----
 fs/proc/vmcore.c                   |    6 ------
 init/Kconfig                       |   10 ----------
 kernel/sched_debug.c               |    2 --
 kernel/sysctl.c                    |   11 -----------
 16 files changed, 25 insertions(+), 99 deletions(-)

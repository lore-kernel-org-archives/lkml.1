Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZAZN1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZAZN1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZAZN0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:26:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZAZN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:26:36 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 0/5] Add preadv & pwritev system calls.
Date: Mon, 26 Jan 2009 14:26:24 +0100
Message-Id: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi folks,

Next round of the preadv & pwritev patch series.  The whitespace bugs
should finally be gone now, checkpatch has nothing to complain about.

There is now a git tree with the patches (branch 'preadv'):
  git://git.et.redhat.com/kernel-kraxel.git
  http://git.et.redhat.com/?p=kernel-kraxel.git;a=shortlog;h=refs/heads/preadv

Plan it so get this into the linux-next once it comes back to life (after
LCA?).

As for userspace bits someone asked for:

Qemu wants use that to handle virtual disk I/O.  A patch for qemu can be
found here: http://article.gmane.org/gmane.comp.emulators.qemu/36851
The code can't put into use yet though as the qemu block layer needs
some changes to pass though iovecs to the disk image format driver code.

Note this isn't the first attempt to get preadv support into the kernel,
therefore I expect others (databases?) will quickly use that too.

Also *BSD has this syscall for quite some time, thus there likely is
code using this in the wild already ...

cheers,
  Gerd


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZEMQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZEMQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbZEMQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:12:14 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:55598 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760331AbZEMQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:12:12 -0400
Message-ID: <4A0AF168.5000801@lougher.demon.co.uk>
Date: Wed, 13 May 2009 17:12:24 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Squashfs fixes for 2.6.30?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs fixes.  They fix some issues with
Squashfs filesystems on architectures with larger than 4K page sizes.  Plus there's
a trivial code tidy.

Please pull from

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Doug Chapman (1):
       Squashfs: fix breakage when page size > metadata block size

Phillip Lougher (2):
       Squashfs: check page size is not larger than the filesystem block size
       Squashfs: cody tidying, remove commented out line in Makefile

  fs/squashfs/Makefile |    1 -
  fs/squashfs/cache.c  |    1 +
  fs/squashfs/super.c  |   10 ++++++++++
  3 files changed, 11 insertions(+), 1 deletions(-)

Thanks

Phillip


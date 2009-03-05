Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZCEBzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZCEBzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZCEByy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:54:54 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37644 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbZCEByx (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:54:53 -0500
Message-ID: <49AF30EC.8010205@lougher.demon.co.uk>
Date: Thu, 05 Mar 2009 01:54:52 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Squashfs fixes for 2.6.29?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs fixes.  They fix some 
potential oopses when dealing with corrupted filesystems (plus a trivial 
documentation typo fix).

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git

Phillip Lougher (2):
     Squashfs: Fix oops when reading fsfuzzer corrupted filesystems
     Squashfs: fix documentation typo, Cramfs filesystem limit is 256 MiB

Roel Kluin (1):
     Squashfs: frag_size should be signed, as it can hold an error result

  Documentation/filesystems/squashfs.txt |    2 +-
  fs/squashfs/block.c                    |   13 +++++++++++--
  fs/squashfs/cache.c                    |    4 ++--
  fs/squashfs/inode.c                    |    6 ++++--
  fs/squashfs/squashfs.h                 |    2 +-
  fs/squashfs/super.c                    |    2 +-
  6 files changed, 20 insertions(+), 9 deletions(-)

Thanks

Phillip

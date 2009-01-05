Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZAEXK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZAEXK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZAEXKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:10:15 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:52488 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZAEXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ix9pNTnbNMO51KGzP1nninrQkH3exU/ZJfzTrgMZkhJVcApQoKmbdC6LQK3m2d/cXE
         RCyOxD1SBdx6R6CaxauqCcYgHq+zHSrZezoAW4e5fG5WA5HC4/9Xn5ifZT8CrDPUdgjz
         9JDUrmstdFT9f86ge9EFgGfPq3TosuULVhSIo=
Date: Tue, 6 Jan 2009 02:15:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] proc update for 2.6.29-rc1
Message-ID: <20090105231522.GA3368@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus
to
a) get BKL removed from proc internals completely (except when near ->ioctl
   callback), and
b) /proc/*/stack which is /proc/*/wchan done right, and
c) several trivial cleanups

 Documentation/filesystems/proc.txt |    1 +
 arch/mips/kernel/stacktrace.c      |   24 +++-
 fs/proc/base.c                     |  231 ++++++++++++++++++++----------------
 fs/proc/generic.c                  |    8 +-
 fs/proc/inode.c                    |    3 -
 fs/proc/proc_net.c                 |    2 +-
 fs/proc/root.c                     |    8 +-
 7 files changed, 153 insertions(+), 124 deletions(-)

Alexey Dobriyan (3):
      proc: stop using BKL
      proc: remove useless WARN_ONs
      proc: remove '##' usage

Hannes Eder (1):
      proc: fix sparse warning

Ken Chen (1):
      proc: add /proc/*/stack

WANG Cong (1):
      proc: remove write-only variable in proc_pident_lookup()

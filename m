Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYGSVQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYGSVQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYGSVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:16:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45732 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYGSVQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:16:16 -0400
Date: Sun, 20 Jul 2008 00:15:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.62-rc1
Message-ID: <20080719211547.GO18326@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.61:
- CVE-2008-0598: mm: trim more holes
- CVE-2008-2826: sctp: Make sure N * sizeof(union sctp_addr) does not overflow.


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.61:

Adrian Bunk (4):
      unexport swap_page
      unexport gameport_{cooked_read,set_name}
      kconfig: move the option SCSI_HPTIOP to a better place
      Linux 2.6.16.62-rc1

Alan Stern (1):
      USB: remove short initial timeout for device descriptor fetch

David S. Miller (1):
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow. (CVE-2008-2826)

Ian Pickworth (1):
      V4L/DVB (3393): Cx88: reduce excessive logging

Ivan Kokshaysky (2):
      moduleparam: fix alpha, ia64 and ppc64 compile failures
      alpha: build fixes - force architecture

Nick Piggin (1):
      mm: trim more holes (CVE-2008-0598)

Tony Luck (1):
      [IA64] Fix unaligned handler for floating point instructions with base update


 Makefile                              |    2 
 arch/alpha/kernel/sys_titan.c         |    3 
 arch/ia64/kernel/unaligned.c          |   11 ++-
 drivers/input/gameport/gameport.c     |    2 
 drivers/media/video/cx88/cx88-video.c |   14 ++--
 drivers/scsi/Kconfig                  |   20 +++---
 drivers/usb/core/hub.c                |   11 +--
 include/asm-alpha/compiler.h          |   47 +++++++++++----
 include/linux/moduleparam.h           |   12 +++
 mm/filemap.c                          |   80 +++++++++++++-------------
 mm/vmscan.c                           |    1 
 net/sctp/socket.c                     |    4 -
 12 files changed, 119 insertions(+), 88 deletions(-)


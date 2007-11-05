Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXKEWwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXKEWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXKEWwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:52:36 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52179 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbXKEWwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:52:35 -0500
Date: Mon, 5 Nov 2007 23:52:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.57
Message-ID: <20071105225210.GD3444@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.56:
- CVE-2007-3740: CIFS should honour umask
- CVE-2007-4308: aacraid: fix security hole
- CVE-2007-4997: [IEEE80211]: avoid integer underflow for runt rx frames
- CVE-2007-5093: USB: fix DoS in pwc USB video driver


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.56:

Adit Ranadive (1):
      [PKTGEN]: srcmac fix

Adrian Bunk (2):
      Linux 2.6.16.57-rc1
      Linux 2.6.16.57

Alan Cox (1):
      aacraid: fix security hole (CVE-2007-4308)

Alexey Dobriyan (1):
      optical /proc/ide/*/media

Chris Wright (1):
      [SPARC64] pass correct addr in get_fb_unmapped_area(MAP_FIXED)

Danny Kukawka (1):
      ide: add "optical" to sysfs "media" attribute

David S. Miller (1):
      [SPARC64]: Fix show_stack() when stack argument is NULL.

Herbert Xu (1):
      [SNAP]: Check packet length before reading

John W. Linville (1):
      [IEEE80211]: avoid integer underflow for runt rx frames (CVE-2007-4997)

Neil Brown (1):
      knfsd: allow nfsd READDIR to return 64bit cookies

Nick Piggin (1):
      buffer: memorder fix

Ohad Ben-Cohen (2):
      [Bluetooth] Fix unintentional fall-through in HCI line discipline
      [Bluetooth] Fix NULL pointer dereference in HCI line discipline

Oliver Neukum (2):
      USB: fix DoS in pwc USB video driver (CVE-2007-5093)
      Fix oops in pwc v4l driver

Patrick McHardy (1):
      [ICMP]: Fix icmp_errors_use_inbound_ifaddr sysctl

Ranko Zivojnovic (1):
      [NET]: gen_estimator deadlock fix

Steve French (1):
      CIFS should honour umask (CVE-2007-3740)


 Makefile                        |    2 
 arch/sparc64/kernel/sys_sparc.c |    2 
 arch/sparc64/kernel/traps.c     |   18 ++--
 arch/sparc64/mm/fault.c         |    5 -
 drivers/bluetooth/hci_ldisc.c   |    5 -
 drivers/ide/ide-proc.c          |    2 
 drivers/ide/ide.c               |    2 
 drivers/scsi/aacraid/linit.c    |    4 
 drivers/usb/media/pwc/pwc-if.c  |  142 +++++++++++++++++++++++---------
 drivers/usb/media/pwc/pwc.h     |    1 
 fs/buffer.c                     |    1 
 fs/cifs/dir.c                   |    6 -
 fs/cifs/inode.c                 |    5 -
 fs/nfsd/nfs3xdr.c               |    6 -
 net/802/psnap.c                 |   17 ++-
 net/core/gen_estimator.c        |   81 +++++++++++-------
 net/core/pktgen.c               |   10 ++
 net/ieee80211/ieee80211_rx.c    |    6 +
 net/ipv4/icmp.c                 |   12 ++
 19 files changed, 229 insertions(+), 98 deletions(-)


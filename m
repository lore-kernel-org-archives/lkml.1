Return-Path: <linux-kernel-owner+w=401wt.eu-S1161027AbXBRBOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbXBRBOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161020AbXBRBOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:14:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33151 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965523AbXBRBOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:14:02 -0500
Date: Sun, 18 Feb 2007 02:14:07 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.41
Message-ID: <20070218011406.GT13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.40:

Adrian Bunk (4):
      Revert "[Bluetooth] Fix compat ioctl for BNEP, CMTP and HIDP"
      [ALSA] echo3g_dsp.c shouldn't include #include <linux/irq.h>
      Linux 2.6.16.41-rc1
      Linux 2.6.16.41

Al Viro (1):
      [TCP]: struct tcp_sack_block annotations

Baruch Even (1):
      TCP: Fix sorting of SACK blocks.

Bob Breuer (1):
      SPARC32: Fix over-optimization by GCC near ip_fast_csum.

Daniel Walker (1):
      [ATM]: Fix for crash in adummy_init()

David S. Miller (1):
      AF_PACKET: Check device down state before hard header callbacks.

Eric W. Biederman (1):
      DECNET: Handle a failure in neigh_parms_alloc (take 2)

Herbert Xu (1):
      [NETFILTER]: Clear GSO bits for TCP reset packet

Hugh Dickins (1):
      fix umask when noACL kernel meets extN tuned for ACLs

Jeff Dike (1):
      uml: fix signal frame alignment

Jiri Bohac (1):
      [IPX]: Fix NULL pointer dereference on ipx unload

John Heffner (1):
      [TCP]: Don't apply FIN exception to full TSO segments.

Linus Torvalds (1):
      Fix up CIFS for "test_clear_page_dirty()" removal

Masayuki Nakagawa (1):
      TCP: skb is unexpectedly freed.


 Makefile                           |    2 
 arch/um/sys-i386/signal.c          |    2 
 arch/um/sys-x86_64/signal.c        |    5 +
 fs/cifs/file.c                     |   26 ++++++++-
 fs/ext2/super.c                    |    4 +
 fs/ext3/super.c                    |    4 +
 include/asm-sparc/checksum.h       |    2 
 include/linux/tcp.h                |    5 +
 net/atm/common.c                   |    3 -
 net/bluetooth/bnep/sock.c          |   67 ++++++------------------
 net/bluetooth/cmtp/sock.c          |   33 ------------
 net/bluetooth/hidp/sock.c          |   78 -----------------------------
 net/decnet/dn_dev.c                |   11 +++-
 net/ipv4/netfilter/ip_nat_helper.c |    2 
 net/ipv4/netfilter/ipt_REJECT.c    |    3 +
 net/ipv4/tcp_input.c               |   17 +++---
 net/ipv4/tcp_output.c              |    3 -
 net/ipx/af_ipx.c                   |   24 +++++---
 net/packet/af_packet.c             |   16 ++---
 sound/pci/echoaudio/echo3g_dsp.c   |    2 
 20 files changed, 111 insertions(+), 198 deletions(-)



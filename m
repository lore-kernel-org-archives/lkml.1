Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXBWKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXBWKKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXBWKKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:10:38 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42109 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932097AbXBWKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:10:36 -0500
Date: Fri, 23 Feb 2007 11:10:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.42-rc1
Message-ID: <20070223101036.GA12392@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.41:
- CVE-2006-5753: fix bad_inode_ops memory corruption
- CVE-2007-0006: Keys: Fix key serial number collision handling
- CVE-2007-0772: Fix a free-wrong-pointer bug in nfs/acl server


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.41:

Adrian Bunk (1):
      Linux 2.6.16.42-rc1

Al Viro (2):
      ATM horizon.c: missing __devinit
      fix rtl8150

Alexey Dobriyan (1):
      [ATM] ambassador, firestream: "-1 >>" is implementation defined

Dan Streetman (1):
      USB: add ZyXEL vendor/product ID to rtl8150 driver

David Howells (1):
      Keys: Fix key serial number collision handling (CVE-2007-0006)

David S. Miller (1):
      [ATM] horizon: read_bia() needs to be __devinit

Eric Sandeen (1):
      fix bad_inode_ops memory corruption (CVE-2006-5753)

Greg Banks (1):
      Fix a free-wrong-pointer bug in nfs/acl server (CVE-2007-0772)

Jeff Garzik (1):
      [ATM] firestream: handle thrown error

Marcel Holtmann (2):
      [Bluetooth] Missing endian swapping for L2CAP socket list
      [Bluetooth] Restrict well known PSM to privileged users

Oleg Nesterov (1):
      V4L/DVB: Buf_qbuf: fix: videobuf_queue->stream corruption and lockup

Petko Manolov (1):
      USB: rtl8150 new device id

Stephen Hemminger (2):
      sky2: fix for NAPI with dual port boards
      sky2: dual-port pci-x checksum fix


 Makefile                        |    2 
 drivers/atm/ambassador.c        |    2 
 drivers/atm/firestream.c        |    6 
 drivers/atm/horizon.c           |    4 
 drivers/media/video/video-buf.c |    1 
 drivers/net/sky2.c              |   27 ++
 drivers/usb/net/rtl8150.c       |   12 -
 fs/bad_inode.c                  |  330 +++++++++++++++++++++++++++-----
 fs/nfsd/nfs2acl.c               |   17 +
 net/bluetooth/l2cap.c           |   10 
 security/keys/key.c             |   33 +--
 11 files changed, 366 insertions(+), 78 deletions(-)



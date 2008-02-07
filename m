Return-Path: <linux-kernel-owner+w=401wt.eu-S932756AbYBGUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbYBGUDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYBGUDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:39216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYBGUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TPA0DMO1nQIXHlVGxI8nOjwZUkhQNC97CR6cxmMbQVh2oI8PJ8jyYGYSuCjygLAeqrTp9J+OamY18Wiz94p4JIUuVEt53Xr9L2hjT7DXLnXuD9RyNx0vuJwTZwYjj6W5ySw7FED4tQqt4WQrOfIUzoUF3eA7vl8V/eYgPyZ7IsU=
Message-ID: <6101e8c40802071203s6f50b292k9d77f8ad1d816f98@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:05 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {00/14+1} - series for stable - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESEND as you yesterday asked (in plain  text), and plus:

*add git id for all patches
*add my CC
*remove shon included patches

--------
stats:

Andrea Arcangeli (1):
      Race condition in userspace testcase

J. Bruce Fields (2):
      knfsd: fix spurious EINVAL errors on first access of new filesystem
      knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME

Jesper Juhl (1):
      cciss: fix memory leak

Kees Cook (1):
      pci: fix unterminated pci_device_id lists

Lee Schermerhorn (1):
      Panic in blk_rq_map_sg() from CCISS driver

Mattia Dongili (1):
      sony-laptop: call sonypi_compat_init earlier

Peter Zijlstra (1):
      i386: fixup TRACE_IRQ breakage

Roland McGrath (1):
      Handle bogus %cs selector in single-step instruction decoding

Stephen Hemminger (2):
      Don't oops on MTU change.
      via-velocity: don't oops on MTU change (resend)

Trond Myklebust (3):
      NFS: Fix nfs_reval_fsid()
      NFS: Fix an Oops in encode_lookup()
      NFSv2/v3: Fix a memory leak when using -onolock

Wang Zhenyu (1):
      Intel_agp: really fix 945/965GME

-------

 arch/i386/kernel/entry.S                        |    2 -
 arch/i386/kernel/ptrace.c                       |   22 ++++++++++----
 arch/i386/kernel/traps.c                        |   10 ++++--
 arch/x86_64/kernel/ptrace.c                     |   23 ++++++++++----
 drivers/block/cciss.c                           |    6 +++-
 drivers/char/agp/intel-agp.c                    |   17 ++++++++---
 drivers/char/ipmi/ipmi_si_intf.c                |    3 +-
 drivers/media/video/usbvision/usbvision-cards.c |    1 +
 drivers/misc/sony-laptop.c                      |   15 ++++++----
 drivers/mtd/nand/cafe_nand.c                    |    3 +-
 drivers/net/via-velocity.c                      |   16 +++++-----
 fs/bio.c                                        |    9 ++++++
 fs/nfs/client.c                                 |   35 ++++++++++++++--------
 fs/nfs/dir.c                                    |   11 ++++---
 fs/nfs/getroot.c                                |    3 ++
 fs/nfs/inode.c                                  |    4 +-
 fs/nfsd/nfs2acl.c                               |    2 +-
 fs/nfsd/nfs3acl.c                               |    2 +-
 fs/nfsd/nfs4xdr.c                               |    5 ++-
 19 files changed, 123 insertions(+), 66 deletions(-)

-- 
Thanks,
Oliver

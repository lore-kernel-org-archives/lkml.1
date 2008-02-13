Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYBMMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYBMMWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYBMMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:22:46 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53779 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYBMMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:22:45 -0500
Date: Wed, 13 Feb 2008 14:22:43 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: jaharkes@cs.cmu.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/coda: remove static inline forward declarations
Message-ID: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-1384520503-1202905363=:31652"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-1384520503-1202905363=:31652
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

They're defined later on in the same file with bodies and
nothingin between needs them.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/coda_linux.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
index 1c47a34..31b7531 100644
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -43,9 +43,6 @@ int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
 
 /* this file:  heloers */
-static __inline__ struct CodaFid *coda_i2f(struct inode *);
-static __inline__ char *coda_i2s(struct inode *);
-static __inline__ void coda_flag_inode(struct inode *, int flag);
 char *coda_f2s(struct CodaFid *f);
 int coda_isroot(struct inode *i);
 int coda_iscontrol(const char *name, size_t length);
-- 
1.5.2.2

---696243703-1384520503-1202905363=:31652--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbXKSMwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbXKSMwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXKSMwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:52:12 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:30542 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXKSMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:52:10 -0500
Date: Mon, 19 Nov 2007 13:52:06 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] tty: Add the new termios2 ioctls to the compatible
	list.
Message-ID: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Make them depend on TCGETS2. If that one is implemented the rest
should be there as well.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 fs/compat_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -1954,6 +1954,12 @@ ULONG_IOCTL(TIOCSCTTY)
 COMPATIBLE_IOCTL(TIOCGPTN)
 COMPATIBLE_IOCTL(TIOCSPTLCK)
 COMPATIBLE_IOCTL(TIOCSERGETLSR)
+#ifdef TCGETS2
+COMPATIBLE_IOCTL(TCGETS2)
+COMPATIBLE_IOCTL(TCSETS2)
+COMPATIBLE_IOCTL(TCSETSW2)
+COMPATIBLE_IOCTL(TCSETSF2)
+#endif
 /* Little f */
 COMPATIBLE_IOCTL(FIOCLEX)
 COMPATIBLE_IOCTL(FIONCLEX)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbYEVWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbYEVWJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbYEVWJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:09:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43009 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758297AbYEVWJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:09:23 -0400
Date: Thu, 22 May 2008 22:56:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] ncpfs: Push the BKL ioctl down - headers
Message-ID: <20080522225654.745ae5a2@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly missed one

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 9f2d763..cf4f7b0 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -210,7 +210,7 @@ int ncp_date_dos2unix(__le16 time, __le16 date);
 void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
 
 /* linux/fs/ncpfs/ioctl.c */
-int ncp_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long ncp_ioctl(struct file *, unsigned int, unsigned long);
 long ncp_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* linux/fs/ncpfs/sock.c */

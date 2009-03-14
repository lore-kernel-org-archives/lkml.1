Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZCNBWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZCNBWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZCNBTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:49 -0400
Received: from kroah.org ([198.145.64.141]:34784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752303AbZCNBTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:32 2009
Message-Id: <20090314011032.290573366@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 007/114] vt: Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bill Nottingham <notting@redhat.com>

commit 2db69a9340da12a4db44edb7506dd68799aeff55 upstream.

Otherwise, these don't work when called from 32-bit userspace on 64-bit
kernels.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1938,6 +1938,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
+COMPATIBLE_IOCTL(PIO_CMAP)
+COMPATIBLE_IOCTL(GIO_CMAP)
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)



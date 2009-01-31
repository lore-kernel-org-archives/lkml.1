Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZAaC4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZAaC4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZAaCrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:04 -0500
Received: from kroah.org ([198.145.64.141]:55000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755705AbZAaCq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:59 -0500
Date: Fri, 30 Jan 2009 18:40:44 -0800
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
       alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 26/32] include/linux: Add bsg.h to the Kernel exported
	headers
Message-ID: <20090131024044.GA12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="include-linux-add-bsg.h-to-the-kernel-exported-headers.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit a229fc61ef0ee3c30fd193beee0eeb87410227f1 upstream.

bsg.h in current form is perfectly suitable for user-mode
consumption. It is needed together with scsi/sg.h for applications
that want to interface with the bsg driver.

Currently the few projects that use it would copy it over into
the projects. But that is not acceptable for projects that need
to provide source and devel packages for distros.

This should also be submitted to stable 2.6.28 and 2.6.27 since bsg had
a stable API since these Kernels and distro users will need the header
for these kernels a swell

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += bsg.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZCNAVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZCNAVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZCNAS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:28 -0400
Received: from kroah.org ([198.145.64.141]:46642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbZCNAS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000739.667137229@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:15 -0700
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
       alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 07/96] documnt FMODE_ constants
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=documnt-fmode_-constants.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit fc9161e54d0dbf799beff9692ea1cc6237162b85 upstream.

Make sure all FMODE_ constants are documents, and ensure a coherent
style for the already existing comments.

[This is needed for the next patch in the .27 kernel which
 changes fs.h.  This patch makes it easier to handle. - gkh]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fs.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -63,18 +63,17 @@ extern int dir_notify_enable;
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
-#define FMODE_READ 1
-#define FMODE_WRITE 2
-
-/* Internal kernel extensions */
-#define FMODE_LSEEK	4
-#define FMODE_PREAD	8
-#define FMODE_PWRITE	FMODE_PREAD	/* These go hand in hand */
-
-/* File is being opened for execution. Primary users of this flag are
-   distributed filesystems that can use it to achieve correct ETXTBUSY
-   behavior for cross-node execution/opening_for_writing of files */
-#define FMODE_EXEC	16
+/* file is open for reading */
+#define FMODE_READ		(1)
+/* file is open for writing */
+#define FMODE_WRITE		(2)
+/* file is seekable */
+#define FMODE_LSEEK		(4)
+/* file can be accessed using pread/pwrite */
+#define FMODE_PREAD		(8)
+#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* File is opened for execution with sys_execve / sys_uselib */
+#define FMODE_EXEC		(16)
 
 #define RW_MASK		1
 #define RWA_MASK	2



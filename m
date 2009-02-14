Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbZBNBPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbZBNBPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZBNBCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:02:02 -0500
Received: from kroah.org ([198.145.64.141]:39870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761458AbZBNBB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:59 -0500
Date: Fri, 13 Feb 2009 16:59:17 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 37/47] sparc: Enable syscall wrappers for 64-bit
	(CVE-2009-0029)
Message-ID: <20090214005917.GL11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-enable-syscall-wrappers-for-64-bit.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 67605d6812691bbd2158d2f60259e0407611bc1b ]

sparc64 needs sign-extended function parameters. We have to enable
the system call wrappers.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -15,6 +15,7 @@ config SPARC64
 	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_LMB
+	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_ARCH_KGDB
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_ARCH_TRACEHOOK


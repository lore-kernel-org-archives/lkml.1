Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbZKFWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbZKFWbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbZKFWbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:31:15 -0500
Received: from kroah.org ([198.145.64.141]:57034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578AbZKFWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221548.274202771@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: [69/99] alpha: fix build after vmlinux.lds.S cleanup
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=alpha-fix-build-after-vmlinux.lds.s-cleanup.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sam Ravnborg <sam@ravnborg.org>

commit de078ef55c74d02ee93d44513da5ee88a089d71d upstream.

Add include to get missing THREAD_SIZE definition

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
 #include <asm/page.h>
 
 OUTPUT_FORMAT("elf64-alpha")



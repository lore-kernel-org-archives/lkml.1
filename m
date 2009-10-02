Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZJBCBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZJBCBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZJBCBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:01:22 -0400
Received: from kroah.org ([198.145.64.141]:32894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZJBBcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.224774494@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [010/136] drivers/mfd/ab3100-core.c: fix powerpc build error
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drivers-mfd-ab3100-core.c-fix-powerpc-build-error.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

commit 00d3803b656a5f0935518d746f6bb27d5181d29d upstream.

drivers/mfd/ab3100-core.c:647: error: ab3100_init_settings causes a section type conflict

Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/ab3100-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -643,7 +643,7 @@ struct ab3100_init_setting {
 	u8 setting;
 };
 
-static const struct ab3100_init_setting __initdata
+static const struct ab3100_init_setting __initconst
 ab3100_init_settings[] = {
 	{
 		.abreg = AB3100_MCA,



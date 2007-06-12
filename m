Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbXFLXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbXFLXDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXFLXDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:03:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33078 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754005AbXFLXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:03:06 -0400
Date: Wed, 13 Jun 2007 01:03:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] drivers/acpi/processor_throttling.c: make 2 functions
	static
Message-ID: <20070612230317.GB3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm1:
> 
>  git-acpi.patch
>...
>  git trees
>...

This patch makes 2 needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc4-mm2/drivers/acpi/processor_throttling.c.old	2007-06-12 23:57:53.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/acpi/processor_throttling.c	2007-06-12 23:58:22.000000000 +0200
@@ -410,7 +410,8 @@
 	return pr->throttling.acpi_processor_get_throttling(pr);
 }
 
-int acpi_processor_set_throttling_fadt(struct acpi_processor *pr, int state)
+static int acpi_processor_set_throttling_fadt(struct acpi_processor *pr,
+					      int state)
 {
 	u32 value = 0;
 	u32 duty_mask = 0;
@@ -482,7 +483,8 @@
 	return 0;
 }
 
-int acpi_processor_set_throttling_ptc(struct acpi_processor *pr, int state)
+static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
+					     int state)
 {
 	u32 value = 0;
 


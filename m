Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0AOCsb (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0AOCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:48:31 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15479 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751937Ab0AOCsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:48:30 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/partitions/check.c: make local symbol static
Date: Thu, 14 Jan 2010 19:48:36 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141948.36170.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/partitions/check.c: make local symbol static

The symbol part_alignment_offset_show is only used locally
in this file. Make it static to prevent the following sparse warning:

warning: symbol 'part_alignment_offset_show' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 64bc899..9814e22 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -219,7 +219,7 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
-ssize_t part_alignment_offset_show(struct device *dev,
+static ssize_t part_alignment_offset_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);

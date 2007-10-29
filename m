Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXJ2Gcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXJ2Gcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbXJ2GcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:32:04 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:33564 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916AbXJ2GcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:32:03 -0400
Message-ID: <47257E58.2030606@sw.ru>
Date: Mon, 29 Oct 2007 09:31:52 +0300
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com, devel@openvz.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: dm: struct io_restriction reordered
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it saves some bytes memory

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -110,12 +110,12 @@ struct target_type {
 };

 struct io_restrictions {
+	unsigned long		seg_boundary_mask;
 	unsigned int		max_sectors;
+	unsigned int		max_segment_size;
 	unsigned short		max_phys_segments;
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
-	unsigned int		max_segment_size;
-	unsigned long		seg_boundary_mask;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
 };


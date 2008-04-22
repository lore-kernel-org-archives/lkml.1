Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbYDVR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbYDVR6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYDVR6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:58:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46166 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYDVR6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:58:24 -0400
Subject: [PATCH] add vmstat_text for NR_WRITEBACK_TEMP
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mszeredi@suse.cz, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 22 Apr 2008 13:58:49 -0400
Message-Id: <1208887130.5534.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH - add vmstat_test for NR_WRITEBACK_TEMP

Against:  2.6.25-rc8-mm2 [maybe also missing in '.25-mm1]

/proc/vmstat items after "nr_vmscan_write" are off-by-one
because of missing test for NR_WRITEBACK_TEMP that was added
to mmzone.h.  

Apparently from:

	mm-add-nr_writeback_temp-counter.patch

in -mm tree.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.25-rc8-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.25-rc8-mm2.orig/mm/vmstat.c	2008-04-15 12:07:18.000000000 -0400
+++ linux-2.6.25-rc8-mm2/mm/vmstat.c	2008-04-15 12:11:48.000000000 -0400
@@ -699,6 +699,7 @@ static const char * const vmstat_text[] 
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_writeback_temp",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",



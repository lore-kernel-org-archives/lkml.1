Return-Path: <linux-kernel-owner+w=401wt.eu-S966290AbXDDCmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966290AbXDDCmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966303AbXDDCmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:42:20 -0400
Received: from waste.org ([66.93.16.53]:54624 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966290AbXDDCmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:19 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
Message-Id: <1.486631555@selenic.com>
Subject: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Date: Tue, 03 Apr 2007 21:43:30 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces /proc/pid/pagemap and /proc/kpagemap,
which allow detailed run-time examination of process memory usage at a
page granularity.

The first several patches whip the page-walking code introduced for
/proc/pid/smaps and clear_refs into a more generic form, the next
couple make those interfaces optional, and the last two introduce the
new interfaces, also optional.

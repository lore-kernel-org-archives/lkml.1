Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXDFWBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXDFWBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXDFWBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:01:39 -0400
Received: from waste.org ([66.93.16.53]:8270 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932563AbXDFWBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:01:36 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
Message-Id: <1.469046093@selenic.com>
Subject: [PATCH 0/13] maps#2: pagemap, kpagemap, and related cleanups take 2
Date: Fri, 06 Apr 2007 17:03:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces /proc/pid/pagemap and /proc/kpagemap,
which allow detailed run-time examination of process memory usage at a
page granularity.

The first several patches whip the page-walking code introduced for
/proc/pid/smaps and clear_refs into a more generic form, the next
couple make those interfaces optional, and the last two introduce the
new interfaces, also optional.

This respin adds simple, expandable headers to both pagemap and
kpagemap as suggested by Nikita. I haven't moved pagewalk.c from lib/
to mm/ as suggested by Nick as I still think lib is a better fit for
its automatic conditional linking.

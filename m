Return-Path: <linux-kernel-owner+w=401wt.eu-S933763AbXCUTPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbXCUTPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933804AbXCUTPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:15:23 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1754 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788AbXCUTPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:15:22 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <hansendc@us.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] pfn_valid_within() HOLES_WITHIN_ZONES helper
References: <Pine.LNX.4.64.0703211510340.15309@skynet.skynet.ie>
InReply-To: <Pine.LNX.4.64.0703211510340.15309@skynet.skynet.ie>
Message-ID: <exportbomb.1174504472@pinky>
Date: Wed, 21 Mar 2007 19:14:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The thought of having a helper for the holes within zones code
has come up on two different threads in the last couple of days.
So I took the pfn_valid_within() patch I had developed for the
linear reclaim series and pulled it forward to 2.6.21-rc4-mm1.
I have split it into a three patch series to better align with the
affected patch sets within -mm.

add-pfn_valid_within-helper-for-sub-MAX_ORDER-hole-detection --
  adds the base helper and utilises it within the buddy allocator,

anti-fragmentation-switch-over-to-pfn_valid_within() -- changes
  references within Mel Gormans anti-fragmentation patch series, and

lumpy-move-to-using-pfn_valid_within() -- changes references with
  my lumpy reclaim patch series.

-apw

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998Ab0A3Jic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0A3Jic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543Ab0A3Jic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:38:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:41383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab0A3Jib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:38:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="536025097"
Message-Id: <20100130092509.793222613@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:25:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 0/4] hwpoison checks for /dev/mem etc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew and Andi,

This -mm patchset adds hwpoison check for

- /dev/mem
- /dev/kmem
- /proc/kcore

and a trivial hwpoison fix.

It tries to do minimal change, by removing the previously debated
vread/vwrite simplification.

Thanks,
Fengguang


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370Ab0AMOAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0AMOAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951Ab0AMOAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:00:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:11393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab0AMOAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:00:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,268,1262592000"; 
   d="scan'208";a="483648841"
Message-Id: <20100113135305.013124116@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jan 2010 21:53:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 0/8] devmem/kmem/kcore fixes, cleanups and hwpoison checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are some patches on mem/kmem/kcore.
Most of them have been individually reviewed in LKML.

bug fixes
	[PATCH 1/8] vfs: fix too big f_pos handling
	[PATCH 2/8] devmem: check vmalloc address on kmem read/write
	[PATCH 3/8] devmem: fix kmem write bug on memory holes

simplify vread/vwrite 
	[PATCH 4/8] resources: introduce generic page_is_ram()
	[PATCH 5/8] vmalloc: simplify vread()/vwrite()

check for corrupted page
	[PATCH 6/8] hwpoison: prevent /dev/kmem from accessing hwpoison pages
	[PATCH 7/8] hwpoison: prevent /dev/mem from accessing hwpoison pages
	[PATCH 8/8] hwpoison: prevent /dev/kcore from accessing hwpoison pages

Thanks,
Fengguang


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYCaLcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYCaLcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCaLca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:32:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYCaLc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:32:29 -0400
Subject: Re: [2.6 patch] mm/page_alloc.c: cleanups
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080330225335.GF28445@cs181133002.pp.htv.fi>
References: <20080330225335.GF28445@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 13:32:18 +0200
Message-Id: <1206963138.8514.637.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 01:53 +0300, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the following needlessly global variables static:
>   - required_kernelcore
>   - zone_movable_pfn[]
> - make the following needlessly global functions static:
>   - move_freepages()
>   - move_freepages_block()
>   - setup_pageset()
>   - find_usable_zone_for_movable()
>   - adjust_zone_range_for_zone_movable()
>   - __absent_pages_in_range()
>   - find_min_pfn_for_node()
>   - find_zone_movable_pfns_for_nodes()
> - #if 0 the following no longer used global function:
>   - free_cold_page()

Why no outright removal? #if 0 only leaves more junk around to clean up
later.


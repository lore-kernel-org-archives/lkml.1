Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYIRSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYIRSVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYIRSVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:21:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38883 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYIRSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:21:00 -0400
Date: Thu, 18 Sep 2008 20:25:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, andi@firstfloor.org,
       joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080918182528.GP25711@one.firstfloor.org>
References: <20080916134335.GC25711@one.firstfloor.org> <20080917021319O.fujita.tomonori@lab.ntt.co.jp> <20080916175824.GF25711@one.firstfloor.org> <20080917085335F.fujita.tomonori@lab.ntt.co.jp> <20080917104327.GD18764@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917104327.GD18764@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> no - any extra layer of robustness is good in such a critical piece of 

robustness would require to handle it everywhere (as in always fall
back to 24bit DMA bouncing if someone tries a map_* on a < 32bit mapping), 
but this patch doesn't do that at all.

-Andi
-- 
ak@linux.intel.com

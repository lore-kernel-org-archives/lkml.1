Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYLJT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYLJT6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYLJT6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:58:39 -0500
Received: from waste.org ([66.93.16.53]:41326 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbYLJT6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:58:38 -0500
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob
	kmem_cache_create
From: Matt Mackall <mpm@selenic.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 13:58:21 -0600
Message-Id: <1228939101.3726.136.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 17:36 +0000, Catalin Marinas wrote:
> It looks like the kmem_cache_create() function in the slob allocator
> passes the SLAB flags as GFP flags to the slob_alloc() function. The
> patch changes this call to pass GFP_KERNEL as the other allocators seem
> to do.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Matt Mackall <mpm@selenic.com>

Good catch.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYLKJrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYLKJrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYLKJrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:47:47 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45532 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYLKJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:47:47 -0500
Subject: Re: [PATCH 04/15] kmemleak: Add the slob memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1228934161.3726.124.camel@calx>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182716.30323.13359.stgit@pc1117.cambridge.arm.com>
	 <1228934161.3726.124.camel@calx>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Dec 2008 09:47:33 +0000
Message-Id: <1228988853.332.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2008 09:47:34.0437 (UTC) FILETIME=[7E42AD50:01C95B75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 12:36 -0600, Matt Mackall wrote:
> On Wed, 2008-12-10 at 18:27 +0000, Catalin Marinas wrote:
> > This patch adds the callbacks to memleak_(alloc|free) functions from the
> > slob allocator.
> 
> Is this different than the last one?

Slightly. It now passes the gfp flags to the memleak_alloc callback
(that's how I noticed that slob_alloc gets the SLAB_* flags).

> Acked-by: Matt Mackall <mpm@selenic.com>

Thanks.

-- 
Catalin


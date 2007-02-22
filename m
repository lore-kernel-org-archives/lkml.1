Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbXBVPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbXBVPeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXBVPeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:34:19 -0500
Received: from waste.org ([66.93.16.53]:41784 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbXBVPeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:34:18 -0500
Date: Thu, 22 Feb 2007 09:21:39 -0600
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       jsipek@fsl.cs.sunysb.edu
Subject: Re: [PATCH 1/2] slab: introduce krealloc
Message-ID: <20070222152139.GI23311@waste.org>
References: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:40:22PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This introduce krealloc() that reallocates memory while keeping the
> contents unchanged. The allocator avoids reallocation if the new size
> fits the currently used cache. I also added a simple non-optimized
> version for mm/slob.c for compatibility.
> 
> Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

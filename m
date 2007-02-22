Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbXBVST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbXBVST0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXBVST0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:19:26 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49191 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbXBVST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:19:26 -0500
Date: Thu, 22 Feb 2007 13:19:13 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       clameter@sgi.com
Subject: Re: [PATCH 1/2] slab: introduce krealloc
Message-ID: <20070222181913.GA29841@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:40:22PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This introduce krealloc() that reallocates memory while keeping the
> contents unchanged. The allocator avoids reallocation if the new size
> fits the currently used cache. I also added a simple non-optimized
> version for mm/slob.c for compatibility.

Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
